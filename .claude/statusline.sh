#!/usr/bin/env bash

# Claude Code Comprehensive Status Line
# Reads session context from stdin (JSON) and outputs detailed metrics

# Read JSON input from stdin
input=$(cat)

# Extract core values
cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // ""')
model_name=$(echo "$input" | jq -r '.model.display_name // ""')
output_style=$(echo "$input" | jq -r '.output_style.name // ""')
session_id=$(echo "$input" | jq -r '.session_id // ""')
version=$(echo "$input" | jq -r '.version // ""')

# Use project_dir if available, otherwise cwd
working_dir="${project_dir:-${cwd:-$(pwd)}}"
dir_name=$(basename "$working_dir")

# ============================================================================
# SPECIAL MODE DETECTION (COFOUNDER, HQ, GLM, etc.)
# ============================================================================
special_mode=""
if [[ "$working_dir" == *"/cofounder"* ]]; then
  special_mode=$(printf '\033[1;35m🤝 COFOUNDER\033[0m')
elif [[ "$working_dir" == *"/glm3"* ]]; then
  special_mode=$(printf '\033[1;36m⚡ GLM3\033[0m')
elif [[ "$working_dir" == *"/HQ"* ]] || [[ "$working_dir" == "/Users/p/HQ"* ]]; then
  special_mode=$(printf '\033[1;33m🎯 HQ\033[0m')
fi

# ============================================================================
# GIT STATUS (uncommitted, branch, ahead/behind)
# ============================================================================
git_info=""
if git -C "$working_dir" rev-parse --git-dir >/dev/null 2>&1; then
  # Branch name
  branch=$(git -C "$working_dir" --no-optional-locks branch --show-current 2>/dev/null)

  # Count uncommitted changes
  modified=$(git -C "$working_dir" --no-optional-locks diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  untracked=$(git -C "$working_dir" --no-optional-locks ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  uncommitted=$((modified + untracked))

  # Ahead/behind remote
  ahead_behind=""
  upstream=$(git -C "$working_dir" --no-optional-locks rev-parse --abbrev-ref @{upstream} 2>/dev/null)
  if [ -n "$upstream" ]; then
    ahead=$(git -C "$working_dir" --no-optional-locks rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
    behind=$(git -C "$working_dir" --no-optional-locks rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")
    if [ "$ahead" -gt 0 ] || [ "$behind" -gt 0 ]; then
      ahead_behind=$(printf " \033[35m↑%s↓%s\033[0m" "$ahead" "$behind")
    fi
  fi

  # Build git info string
  if [ -n "$branch" ]; then
    git_status_color='\033[32m'  # green
    if [ "$uncommitted" -gt 0 ]; then
      git_status_color='\033[33m'  # yellow
    fi
    git_info=$(printf " ${git_status_color}%s\033[0m" "$branch")
    if [ "$uncommitted" -gt 0 ]; then
      git_info="${git_info}$(printf " \033[33m±%s\033[0m" "$uncommitted")"
    fi
    git_info="${git_info}${ahead_behind}"
  fi
fi

# ============================================================================
# SESSION INFO (session ID, time elapsed, message count)
# ============================================================================
session_info=""
if [ -n "$session_id" ]; then
  # Last 6 chars of session ID
  short_id="${session_id: -6}"
  session_info=$(printf "\033[90m#%s\033[0m" "$short_id")

  # Session start time (estimate from transcript if available)
  transcript_path=$(echo "$input" | jq -r '.transcript_path // ""')
  if [ -f "$transcript_path" ]; then
    # Get file creation time in seconds since epoch
    if [[ "$OSTYPE" == "darwin"* ]]; then
      creation_time=$(stat -f %B "$transcript_path" 2>/dev/null)
    else
      creation_time=$(stat -c %Y "$transcript_path" 2>/dev/null)
    fi

    if [ -n "$creation_time" ]; then
      current_time=$(date +%s)
      elapsed=$((current_time - creation_time))

      if [ "$elapsed" -ge 3600 ]; then
        hours=$((elapsed / 3600))
        minutes=$(((elapsed % 3600) / 60))
        time_str=$(printf "%dh%dm" "$hours" "$minutes")
      elif [ "$elapsed" -ge 60 ]; then
        minutes=$((elapsed / 60))
        time_str=$(printf "%dm" "$minutes")
      else
        time_str=$(printf "%ds" "$elapsed")
      fi
      session_info="${session_info} $(printf "\033[90m%s\033[0m" "$time_str")"
    fi

    # Count messages (approximate from transcript lines)
    msg_count=$(grep -c '"role":' "$transcript_path" 2>/dev/null || echo "0")
    if [ "$msg_count" -gt 0 ]; then
      session_info="${session_info} $(printf "\033[90m%s msg\033[0m" "$msg_count")"
    fi
  fi
fi

# ============================================================================
# PROJECT CONTEXT (phase, package name/version)
# ============================================================================
project_info=""

# Get current phase from SESSION_STATE.md
session_state="${working_dir}/.factory/SESSION_STATE.md"
if [ -f "$session_state" ]; then
  phase=$(grep -m 1 "Status:" "$session_state" 2>/dev/null | sed 's/.*Status:\*\* //' | sed 's/ .*//')
  if [ -n "$phase" ]; then
    project_info=$(printf "\033[36m%s\033[0m" "$phase")
  fi
fi

# Get package.json name and version
package_json="${working_dir}/package.json"
if [ -f "$package_json" ]; then
  pkg_name=$(jq -r '.name // ""' "$package_json" 2>/dev/null)
  pkg_version=$(jq -r '.version // "0.0.0"' "$package_json" 2>/dev/null)
  if [ -n "$pkg_name" ]; then
    if [ -n "$project_info" ]; then
      project_info="${project_info} · "
    fi
    project_info="${project_info}$(printf "\033[90m%s@%s\033[0m" "$pkg_name" "$pkg_version")"
  fi
fi

# ============================================================================
# REAL ANTHROPIC WEEKLY USAGE (from Anthropic API - the ACTUAL usage, not estimates)
# ============================================================================
WEEKLY_CACHE="/tmp/.claude_weekly_real_cache"
WEEKLY_CACHE_AGE=999
if [ -f "$WEEKLY_CACHE" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        WEEKLY_CACHE_AGE=$(($(date +%s) - $(LC_ALL=C stat -f %m "$WEEKLY_CACHE" 2>/dev/null || echo 0)))
    else
        WEEKLY_CACHE_AGE=$(($(date +%s) - $(stat -c %Y "$WEEKLY_CACHE" 2>/dev/null || echo 0)))
    fi
fi

WEEKLY_PACE=""
if [ "$WEEKLY_CACHE_AGE" -lt 60 ]; then
    # Use cached value (refresh every 60s)
    WEEKLY_PACE=$(cat "$WEEKLY_CACHE")
else
    # Fetch REAL usage from Anthropic API
    # Try keychain first (macOS), then fall back to file
    CREDS_JSON=""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: read from keychain
        CREDS_JSON=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
    fi
    # Fallback to file if keychain didn't work
    if [ -z "$CREDS_JSON" ] && [ -f "$HOME/.claude/.credentials.json" ]; then
        CREDS_JSON=$(cat "$HOME/.claude/.credentials.json" 2>/dev/null)
    fi
    if [ -n "$CREDS_JSON" ]; then
        TOKEN=$(echo "$CREDS_JSON" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
        if [ -n "$TOKEN" ]; then
            # Call Anthropic's usage API
            API_RESPONSE=$(curl -s --max-time 3 \
                -H "Authorization: Bearer $TOKEN" \
                -H "anthropic-beta: oauth-2025-04-20" \
                -H "Accept: application/json" \
                "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)

            if [ -n "$API_RESPONSE" ] && echo "$API_RESPONSE" | jq -e '.seven_day' >/dev/null 2>&1; then
                # Parse seven_day utilization and reset time
                WEEKLY_PACE=$(echo "$API_RESPONSE" | python3 -c '
import sys, json
from datetime import datetime, timezone, timedelta

try:
    d = json.load(sys.stdin)
    seven_day = d.get("seven_day", {})
    utilization = seven_day.get("utilization", 0)
    resets_at = seven_day.get("resets_at", "")

    if resets_at:
        # Parse reset time (when week ENDS)
        reset_dt = datetime.fromisoformat(resets_at.replace("Z", "+00:00"))
        # Week started 7 days before reset
        week_start = reset_dt.replace(tzinfo=timezone.utc) - timedelta(days=7)
        now = datetime.now(timezone.utc)

        # Calculate elapsed percentage of the week
        week_duration = 7 * 24 * 60 * 60  # 7 days in seconds
        elapsed_seconds = (now - week_start).total_seconds()
        elapsed_pct = min(100, max(0, (elapsed_seconds / week_duration) * 100))

        # Pace: positive = ahead (good), negative = behind (underspending)
        pace = utilization - elapsed_pct

        # Format: A:6%[+2] or A:6%[-3]
        if pace >= 0:
            print(f"A:{utilization:.0f}%[+{pace:.0f}]")
        else:
            print(f"A:{utilization:.0f}%[{pace:.0f}]")
    else:
        print(f"A:{utilization:.0f}%")
except Exception as e:
    print("A:?%")
' 2>/dev/null)
            fi
        fi
    fi

    # Cache result (or fallback)
    [ -z "$WEEKLY_PACE" ] && WEEKLY_PACE="A:?%"
    echo "$WEEKLY_PACE" > "$WEEKLY_CACHE" &
fi

# ============================================================================
# Z.AI QUOTA (GLM tokens - from Z.AI monitor API, FREE endpoint)
# ============================================================================
ZAI_CACHE="/tmp/.zai_quota_cache"
ZAI_CACHE_AGE=999
if [ -f "$ZAI_CACHE" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ZAI_CACHE_AGE=$(($(date +%s) - $(LC_ALL=C stat -f %m "$ZAI_CACHE" 2>/dev/null || echo 0)))
    else
        ZAI_CACHE_AGE=$(($(date +%s) - $(stat -c %Y "$ZAI_CACHE" 2>/dev/null || echo 0)))
    fi
fi

ZAI_STATUS=""
if [ "$ZAI_CACHE_AGE" -lt 60 ]; then
    # Use cached value (refresh every 60s)
    ZAI_STATUS=$(cat "$ZAI_CACHE")
else
    # Fetch from Z.AI monitor API (FREE - doesn't consume quota!)
    ZAI_KEY_FILE="$HOME/dev/opus-router/config.env"
    if [ -f "$ZAI_KEY_FILE" ]; then
        ZAI_KEY=$(grep "^ZAI_KEY=" "$ZAI_KEY_FILE" | cut -d= -f2)
        if [ -n "$ZAI_KEY" ]; then
            ZAI_RESPONSE=$(curl -s --max-time 3 \
                -H "x-api-key: $ZAI_KEY" \
                "https://api.z.ai/api/monitor/usage/quota/limit" 2>/dev/null)

            if [ -n "$ZAI_RESPONSE" ] && echo "$ZAI_RESPONSE" | grep -q '"success":true'; then
                ZAI_STATUS=$(echo "$ZAI_RESPONSE" | python3 -c '
import sys, json
from datetime import datetime

try:
    d = json.load(sys.stdin)
    tok_pct = 0
    hrs_left = 0

    for limit in d["data"]["limits"]:
        if limit["type"] == "TOKENS_LIMIT":
            tok_pct = limit["currentValue"] * 100 / limit["usage"]
            if limit.get("nextResetTime"):
                reset_sec = limit["nextResetTime"] / 1000
                now = datetime.now().timestamp()
                hrs_left = (reset_sec - now) / 3600

    # Format: Z:2%|3.5h
    if hrs_left > 0:
        print(f"Z:{tok_pct:.0f}%|{hrs_left:.1f}h")
    else:
        print(f"Z:{tok_pct:.0f}%")
except:
    print("Z:?%")
' 2>/dev/null)
            fi
        fi
    fi

    # Cache result (or fallback)
    [ -z "$ZAI_STATUS" ] && ZAI_STATUS="Z:?%"
    echo "$ZAI_STATUS" > "$ZAI_CACHE" &
fi

# ============================================================================
# TOKEN ECONOMICS (total tokens, cache hit rate, cost estimate)
# ============================================================================
token_info=""

# Prepend real weekly usage + Z.AI quota
if [ -n "$WEEKLY_PACE" ]; then
    if [ "$WEEKLY_PACE" = "A:?%" ]; then
        token_info=$(printf "\033[90m%s\033[0m" "$WEEKLY_PACE")
    else
        token_info=$(printf "\033[36m%s\033[0m" "$WEEKLY_PACE")
    fi
fi

# Add Z.AI quota (color based on usage)
if [ -n "$ZAI_STATUS" ] && [ "$ZAI_STATUS" != "Z:?%" ]; then
    ZAI_PCT=$(echo "$ZAI_STATUS" | sed 's/Z:\([0-9]*\).*/\1/' 2>/dev/null || echo 0)
    if [ "$ZAI_PCT" -lt 50 ] 2>/dev/null; then
        ZAI_COLOR='\033[32m'  # green
    elif [ "$ZAI_PCT" -lt 80 ] 2>/dev/null; then
        ZAI_COLOR='\033[33m'  # yellow
    else
        ZAI_COLOR='\033[31m'  # red
    fi
    if [ -n "$token_info" ]; then
        token_info="${token_info} $(printf "${ZAI_COLOR}%s\033[0m" "$ZAI_STATUS")"
    else
        token_info=$(printf "${ZAI_COLOR}%s\033[0m" "$ZAI_STATUS")
    fi
elif [ -n "$ZAI_STATUS" ]; then
    # Dim when unavailable
    if [ -n "$token_info" ]; then
        token_info="${token_info} $(printf "\033[90m%s\033[0m" "$ZAI_STATUS")"
    else
        token_info=$(printf "\033[90m%s\033[0m" "$ZAI_STATUS")
    fi
fi

usage=$(echo "$input" | jq '.context_window.current_usage')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

if [ "$usage" != "null" ]; then
  # Current usage for context percentage
  input_tokens=$(echo "$usage" | jq -r '.input_tokens // 0')
  cache_creation=$(echo "$usage" | jq -r '.cache_creation_input_tokens // 0')
  cache_read=$(echo "$usage" | jq -r '.cache_read_input_tokens // 0')
  output_tokens=$(echo "$usage" | jq -r '.output_tokens // 0')

  # Total tokens in session
  total_tokens=$((total_input + total_output))
  if [ "$total_tokens" -gt 0 ]; then
    if [ "$total_tokens" -ge 1000000 ]; then
      token_display=$(printf "%.1fM" "$(echo "scale=1; $total_tokens / 1000000" | bc)")
    elif [ "$total_tokens" -ge 1000 ]; then
      token_display=$(printf "%.0fk" "$(echo "$total_tokens / 1000" | bc)")
    else
      token_display="$total_tokens"
    fi
    if [ -n "$token_info" ]; then
      token_info="${token_info} · "
    fi
    token_info="${token_info}$(printf "\033[33m%s tok\033[0m" "$token_display")"
  fi

  # Cache hit rate
  if [ -n "$cache_read" ] && [ "$cache_read" -gt 0 ] && [ -n "$input_tokens" ] && [ "$input_tokens" -gt 0 ]; then
    cache_total=$((cache_read + input_tokens))
    if [ "$cache_total" -gt 0 ]; then
      cache_pct=$((cache_read * 100 / cache_total))
      if [ -n "$token_info" ]; then
        token_info="${token_info} · "
      fi
      token_info="${token_info}$(printf "\033[32m%d%% cache\033[0m" "$cache_pct")"
    fi
  fi

  # Cost estimate (approximate for Sonnet)
  # Input: $3/M, Cache write: $3.75/M, Cache read: $0.30/M, Output: $15/M
  if [ "$total_tokens" -gt 0 ]; then
    cost=$(echo "scale=3; ($total_input * 3 + $total_output * 15) / 1000000" | bc 2>/dev/null || echo "0")
    if [ "$(echo "$cost > 0.001" | bc 2>/dev/null)" = "1" ]; then
      if [ -n "$token_info" ]; then
        token_info="${token_info} · "
      fi
      token_info="${token_info}$(printf "\033[90m\$%.2f\033[0m" "$cost")"
    fi
  fi

  # Record session to usage tracker (fire and forget, deduped by session_id)
  if [ -n "$session_id" ] && [ -f "$HOME/.claude/usage_tracker.py" ]; then
    # Determine model for pricing
    case "$model_name" in
      *"Opus"*) tracker_model="opus" ;;
      *"Haiku"*) tracker_model="haiku" ;;
      *) tracker_model="sonnet" ;;
    esac
    python3 "$HOME/.claude/usage_tracker.py" record "{\"session_id\":\"$session_id\",\"input\":$total_input,\"output\":$total_output,\"cache_read\":$cache_read,\"cache_write\":$cache_creation,\"model\":\"$tracker_model\"}" 2>/dev/null &
  fi

fi

# Add usage summary OUTSIDE the usage block so it shows even in new sessions
if [ -f "$HOME/.claude/usage_tracker.py" ]; then
  usage_summary=$(python3 "$HOME/.claude/usage_tracker.py" compact 2>/dev/null)
  if [ -n "$usage_summary" ]; then
    if [ -n "$token_info" ]; then
      token_info="${token_info} · $(printf "\033[36m%s\033[0m" "$usage_summary")"
    else
      token_info=$(printf "\033[36m%s\033[0m" "$usage_summary")
    fi
  fi
fi

# ============================================================================
# CONTEXT PERCENTAGE
# ============================================================================
ctx_pct=""
if [ "$usage" != "null" ]; then
  current=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
  size=$(echo "$input" | jq '.context_window.context_window_size')

  if [ "$current" != "null" ] && [ -n "$current" ] && [ "$size" != "null" ] && [ -n "$size" ] && [ "$size" -gt 0 ]; then
    pct=$((current * 100 / size))

    # Color code based on usage
    if [ "$pct" -lt 50 ]; then
      color='\033[32m'  # green
    elif [ "$pct" -lt 75 ]; then
      color='\033[33m'  # yellow
    else
      color='\033[31m'  # red
    fi

    ctx_pct=$(printf "${color}%d%%\033[0m ctx" "$pct")
  fi
else
  # Session start - no usage data yet
  ctx_pct=$(printf '\033[90m--%%\033[0m ctx')
fi

# ============================================================================
# MODEL NAME
# ============================================================================
model_short="$model_name"
if [ -n "$model_name" ]; then
  case "$model_name" in
    *"Sonnet"*) model_short="Sonnet" ;;
    *"Opus"*) model_short="Opus" ;;
    *"Haiku"*) model_short="Haiku" ;;
  esac
  model_short=$(printf '\033[36m%s\033[0m' "$model_short")
fi

# ============================================================================
# TIME/DATE
# ============================================================================
time_str=$(date '+%H:%M')
day_str=$(date '+%a')
datetime=$(printf "\033[90m%s %s\033[0m" "$day_str" "$time_str")

# ============================================================================
# AI FACTORY SPECIFIC (agents, skills, MCP, running subagents, background tasks)
# ============================================================================
factory_info=""

# Static counts (cyan) - from filesystem
agent_count=$(find "$HOME/.claude/agents" -maxdepth 1 -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')
skill_count=$(find "$HOME/.claude/skills" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
mcp_count=$(jq '.mcpServers | keys | length' "$HOME/.claude/mcp.json" 2>/dev/null || echo "0")

# Running counts - live processes
# Running MCP servers (connected)
mcp_running=$(ps aux 2>/dev/null | grep -E "@modelcontextprotocol|mcp-server|lazy-mcp" | grep -v grep | wc -l | tr -d ' ')

# Running subagents (actual claude CLI processes, not helper scripts)
# Match "claude " at start of command (the binary, not scripts in ~/.claude/)
claude_procs=$(ps aux 2>/dev/null | awk '$11 == "claude" || $11 ~ /\/claude$/' | wc -l | tr -d ' ')
subagent_count=$((claude_procs - 1))  # minus 1 for main session
[ "$subagent_count" -lt 0 ] && subagent_count=0

# Background tasks (check for background task output files)
bg_tasks=$(ls /tmp/claude-task-* 2>/dev/null | wc -l | tr -d ' ')
[ -z "$bg_tasks" ] && bg_tasks=0

# Format: 18A·59S·9/12M | R:0·B:0
# Static in cyan, MCP shows running/total
static_info=$(printf "\033[36m%dA·%dS·%d/%dM\033[0m" "$agent_count" "$skill_count" "$mcp_running" "$mcp_count")

# Running info - green if active, grey if idle
if [ "$subagent_count" -gt 0 ] || [ "$bg_tasks" -gt 0 ]; then
    running_info=$(printf "\033[32mR:%d·B:%d\033[0m" "$subagent_count" "$bg_tasks")
else
    running_info=$(printf "\033[90mR:0·B:0\033[0m")
fi

factory_info="${static_info} ${running_info}"

# ============================================================================
# SYSTEM HEALTH (load average, memory)
# ============================================================================
health_info=""
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS load average (1 minute)
  load=$(LC_ALL=C sysctl -n vm.loadavg 2>/dev/null | awk '{print $2}' | cut -d. -f1)
  if [ -n "$load" ]; then
    if [ "$load" -gt 4 ]; then
      load_color='\033[31m'  # red
    elif [ "$load" -gt 2 ]; then
      load_color='\033[33m'  # yellow
    else
      load_color='\033[32m'  # green
    fi
    health_info=$(printf "${load_color}L%s\033[0m" "$load")
  fi

  # Memory pressure (simplified)
  mem_pressure=$(memory_pressure 2>/dev/null | grep "System-wide memory free percentage" | awk '{print $5}' | tr -d '%')
  if [ -n "$mem_pressure" ] && [ "$mem_pressure" -lt 20 ]; then
    if [ -n "$health_info" ]; then
      health_info="${health_info} "
    fi
    health_info="${health_info}$(printf "\033[31mM%s%%\033[0m" "$mem_pressure")"
  fi
fi

# ============================================================================
# OUTPUT STYLE
# ============================================================================
style_indicator=""
if [ -n "$output_style" ] && [ "$output_style" != "default" ]; then
  style_indicator=$(printf '\033[33m[%s]\033[0m' "$output_style")
fi

# ============================================================================
# BUILD STATUS LINE (organized with separators)
# ============================================================================
# Format: [COFOUNDER] dir git | session | project | model style | tokens | ctx | time | factory | health

status_line=""

# Cofounder mode indicator (if active)
if [ -n "$special_mode" ]; then
  status_line="${special_mode} · "
fi

# Directory and git
status_line="${status_line}$(printf '\033[34m%s\033[0m%s' "$dir_name" "$git_info")"

# Session info
if [ -n "$session_info" ]; then
  status_line="${status_line} · ${session_info}"
fi

# Project context
if [ -n "$project_info" ]; then
  status_line="${status_line} · ${project_info}"
fi

# Model and style
status_line="${status_line} · ${model_short}"
if [ -n "$style_indicator" ]; then
  status_line="${status_line} ${style_indicator}"
fi

# Token economics
if [ -n "$token_info" ]; then
  status_line="${status_line} · ${token_info}"
fi

# Time/date
status_line="${status_line} · ${datetime}"

# Factory stats
if [ -n "$factory_info" ]; then
  status_line="${status_line} · ${factory_info}"
fi

# System health
if [ -n "$health_info" ]; then
  status_line="${status_line} · ${health_info}"
fi

# Output the complete status line

# ============================================================================

# PC RESEARCH STATS (workers, queue, DB, Gemini) - single SSH call
pc_data=$(ssh -p 2222 -o ConnectTimeout=1 -o BatchMode=yes p@100.79.92.121 'python3 << "PYEND"
import json
import subprocess
import os

result = {}

# Workers count
try:
    ps = subprocess.run(["pgrep", "-f", "worker_v2"], capture_output=True, text=True)
    result["workers"] = len(ps.stdout.strip().split("\n")) if ps.stdout.strip() else 0
except:
    result["workers"] = 0

# Queue depth (file-based queue)
try:
    from pathlib import Path
    queue_dir = Path("/home/p/dev/research/data/queue")
    # Count .json files without .lock (pending items)
    json_files = list(queue_dir.glob("*.json"))
    lock_stems = set(f.stem for f in queue_dir.glob("*.lock"))
    pending = [f for f in json_files if f.stem not in lock_stems]
    result["queue"] = len(pending)
    # Priority queue (storm_000_* files)
    priority = len([f for f in pending if f.name.startswith("storm_000_")])
    result["priority"] = priority
except:
    result["queue"] = 0
    result["priority"] = 0

# LanceDB rows
try:
    import lancedb
    db = lancedb.connect("/home/p/dev/.brain/lancedb")
    result["db_rows"] = db.open_table("research_neural").count_rows()
except:
    result["db_rows"] = 0

# Gemini usage with fallback tracking
try:
    with open("/home/p/dev/research/state/quota_tracker.json") as f:
        data = json.load(f)
    models = data.get("models", {})
    fallback_state = data.get("fallback_state", {})

    gemini_parts = []
    total_limits = 0

    # Primary models for each chain
    primaries = {"research": "gemini-2.5-flash", "synthesis": "gemini-3-flash-preview"}

    for model in ["gemini-2.5-flash", "gemini-3-flash-preview"]:
        stats = models.get(model, {})
        daily = stats.get("daily_calls", 0)
        limits = stats.get("rate_limits", 0)
        total_limits += limits
        short = model.replace("gemini-", "").replace("-preview", "")
        if daily > 0:
            if limits > 0:
                gemini_parts.append(f"{short}:{daily}[{limits}!]")
            else:
                gemini_parts.append(f"{short}:{daily}")

    # Check for active fallback
    fallback_indicator = ""
    fallback_count = 0
    for chain, state in fallback_state.items():
        active = state.get("active_model", "")
        primary = primaries.get(chain, "")
        fb_count = state.get("fallback_count", 0)
        fallback_count += fb_count
        if active and primary and active != primary:
            # We are in fallback mode
            active_short = active.replace("gemini-", "").replace("-preview", "").replace("-lite", "L")
            fallback_indicator = f"→{active_short}"
            break  # Show first active fallback

    result["gemini"] = " · ".join(gemini_parts)
    result["fallback"] = fallback_indicator
    result["fallback_count"] = fallback_count
    result["total_limits"] = total_limits
    result["has_limit"] = total_limits > 0
except:
    result["gemini"] = ""
    result["fallback"] = ""
    result["fallback_count"] = 0
    result["total_limits"] = 0
    result["has_limit"] = False

print(json.dumps(result))
PYEND
' 2>/dev/null)

# Parse PC data
if [ -n "$pc_data" ]; then
  workers=$(echo "$pc_data" | jq -r '.workers // 0')
  queue=$(echo "$pc_data" | jq -r '.queue // 0')
  priority=$(echo "$pc_data" | jq -r '.priority // 0')
  db_rows=$(echo "$pc_data" | jq -r '.db_rows // 0')
  quota_data=$(echo "$pc_data" | jq -r '.gemini // ""')
  has_limit=$(echo "$pc_data" | jq -r '.has_limit // false')

  # Format DB rows (K suffix for thousands)
  if [ "$db_rows" -ge 1000 ]; then
    db_display="$((db_rows / 1000))K"
  else
    db_display="$db_rows"
  fi

  # Format queue with priority (P:80/1018 or just Q:1018 if no priority)
  if [ "$priority" -gt 0 ]; then
    queue_display="P:${priority}/${queue}"
  else
    queue_display="Q:${queue}"
  fi

  # Add W:Q:DB to status line
  if [ "$workers" -gt 0 ] || [ "$queue" -gt 0 ] || [ "$db_rows" -gt 0 ]; then
    status_line="${status_line} · $(printf '\033[33mW:%s · %s · %s\033[0m' "$workers" "$queue_display" "$db_display")"
  fi
fi

# Display Gemini stats with fallback indicator
if [ -n "$quota_data" ]; then
  fallback=$(echo "$pc_data" | jq -r '.fallback // ""')
  total_limits=$(echo "$pc_data" | jq -r '.total_limits // 0')
  fallback_count=$(echo "$pc_data" | jq -r '.fallback_count // 0')

  # Build gemini display string
  gemini_display=""

  # Add fallback indicator if active (red, prominent)
  if [ -n "$fallback" ]; then
    gemini_display=$(printf '\033[31m%s\033[0m · ' "$fallback")
  fi

  # Color code based on rate limit severity
  if [ "$total_limits" -ge 10 ]; then
    # Critical: red
    gemini_display="${gemini_display}$(printf '\033[31m%s\033[0m' "$quota_data")"
  elif [ "$total_limits" -ge 1 ]; then
    # Warning: yellow
    gemini_display="${gemini_display}$(printf '\033[33m%s\033[0m' "$quota_data")"
  else
    # Normal: cyan
    gemini_display="${gemini_display}$(printf '\033[36m%s\033[0m' "$quota_data")"
  fi

  status_line="${status_line} · ${gemini_display}"
fi

# ============================================================================
# ALIENWARE INFERENCE STATS (GPU, vLLM, Embedding, Mem0) - via SSH
# ============================================================================
ALIEN_CACHE="/tmp/.alienware_inference_cache"
ALIEN_CACHE_AGE=999
if [ -f "$ALIEN_CACHE" ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    ALIEN_CACHE_AGE=$(($(date +%s) - $(LC_ALL=C stat -f %m "$ALIEN_CACHE" 2>/dev/null || echo 0)))
  else
    ALIEN_CACHE_AGE=$(($(date +%s) - $(stat -c %Y "$ALIEN_CACHE" 2>/dev/null || echo 0)))
  fi
fi

if [ "$ALIEN_CACHE_AGE" -lt 10 ]; then
  # Use cached value
  source "$ALIEN_CACHE"
else
  # Fetch comprehensive stats from Alienware (daily + live metrics)
  alien_all=$(ssh -o ConnectTimeout=2 -o BatchMode=yes alien 'python3 << "PYEND"
import json
import subprocess
import urllib.request

result = {}

# Daily stats from inference_history.json
try:
    from datetime import datetime
    hour = int(datetime.now().strftime("%H"))
    if hour < 12:
        from datetime import timedelta
        today = (datetime.now() - timedelta(days=1)).strftime("%Y-%m-%d")
    else:
        today = datetime.now().strftime("%Y-%m-%d")

    with open("/home/p/.claude/inference_history.json") as f:
        data = json.load(f)
    daily = data.get("daily", {}).get(today, {})
    result["vllm_daily"] = daily.get("vllm", {}).get("requests", 0)
    result["embed_daily"] = daily.get("embed", {}).get("requests", 0)
    result["mem0_daily"] = daily.get("mem0", {}).get("requests", 0)
    result["mem0_count"] = daily.get("mem0", {}).get("memory_count", 0)
except:
    result["vllm_daily"] = 0
    result["embed_daily"] = 0
    result["mem0_daily"] = 0
    result["mem0_count"] = 0

# GPU stats
try:
    gpu = subprocess.run(["nvidia-smi", "--query-gpu=temperature.gpu,memory.used,memory.total",
                         "--format=csv,noheader,nounits"], capture_output=True, text=True, timeout=2)
    temp, used, total = gpu.stdout.strip().split(", ")
    result["gpu_temp"] = int(temp)
    result["vram_pct"] = int(int(used) * 100 / int(total))
except:
    result["gpu_temp"] = 0
    result["vram_pct"] = 0

# vLLM live metrics
try:
    metrics = urllib.request.urlopen("http://localhost:8000/metrics", timeout=1).read().decode()
    for line in metrics.split("\n"):
        if line.startswith("vllm:num_requests_running{"):
            result["vllm_running"] = int(float(line.split()[-1]))
        elif line.startswith("vllm:num_requests_waiting{"):
            result["vllm_waiting"] = int(float(line.split()[-1]))
        elif line.startswith("vllm:kv_cache_usage_perc{"):
            result["kv_pct"] = int(float(line.split()[-1]) * 100)
        elif "vllm:generation_tokens_total{" in line:
            result["gen_tokens"] = int(float(line.split()[-1]))
except:
    result["vllm_running"] = 0
    result["vllm_waiting"] = 0
    result["kv_pct"] = 0

# Embedding latency
try:
    stats = json.loads(urllib.request.urlopen("http://localhost:5051/stats", timeout=1).read().decode())
    result["embed_latency"] = int(stats.get("avg_latency_ms", 0))
except:
    result["embed_latency"] = 0

# Mem0 live count
try:
    stats = json.loads(urllib.request.urlopen("http://localhost:8001/stats", timeout=1).read().decode())
    result["mem0_count"] = stats.get("memory_count", result.get("mem0_count", 0))
except:
    pass

print(json.dumps(result))
PYEND
' 2>/dev/null)

  # Parse combined data
  if [ -n "$alien_all" ]; then
    VLLM_DAILY=$(echo "$alien_all" | jq -r '.vllm_daily // 0')
    EMBED_DAILY=$(echo "$alien_all" | jq -r '.embed_daily // 0')
    MEM0_DAILY=$(echo "$alien_all" | jq -r '.mem0_daily // 0')
    MEM0_COUNT=$(echo "$alien_all" | jq -r '.mem0_count // 0')
    GPU_TEMP=$(echo "$alien_all" | jq -r '.gpu_temp // 0')
    VRAM_PCT=$(echo "$alien_all" | jq -r '.vram_pct // 0')
    VLLM_RUNNING=$(echo "$alien_all" | jq -r '.vllm_running // 0')
    VLLM_WAITING=$(echo "$alien_all" | jq -r '.vllm_waiting // 0')
    KV_PCT=$(echo "$alien_all" | jq -r '.kv_pct // 0')
    EMBED_LATENCY=$(echo "$alien_all" | jq -r '.embed_latency // 0')
  else
    VLLM_DAILY=0; EMBED_DAILY=0; MEM0_DAILY=0; MEM0_COUNT=0
    GPU_TEMP=0; VRAM_PCT=0; VLLM_RUNNING=0; VLLM_WAITING=0; KV_PCT=0; EMBED_LATENCY=0
  fi

  # Cache all values
  cat > "$ALIEN_CACHE" << ACACHE
VLLM_DAILY="$VLLM_DAILY"
EMBED_DAILY="$EMBED_DAILY"
MEM0_DAILY="$MEM0_DAILY"
MEM0_COUNT="$MEM0_COUNT"
GPU_TEMP="$GPU_TEMP"
VRAM_PCT="$VRAM_PCT"
VLLM_RUNNING="$VLLM_RUNNING"
VLLM_WAITING="$VLLM_WAITING"
KV_PCT="$KV_PCT"
EMBED_LATENCY="$EMBED_LATENCY"
ACACHE
fi

# Build Alienware status string with all metrics
alien_str=""

# GPU stats (colored by temperature)
if [ "${GPU_TEMP:-0}" -gt 0 ]; then
  if [ "$GPU_TEMP" -lt 60 ]; then
    gpu_color='\033[32m'  # green
  elif [ "$GPU_TEMP" -lt 75 ]; then
    gpu_color='\033[33m'  # yellow
  else
    gpu_color='\033[31m'  # red
  fi
  alien_str=$(printf "${gpu_color}🔥%s°\033[0m V%s%%" "$GPU_TEMP" "${VRAM_PCT:-0}")
fi

# vLLM live status (R=running, W=waiting, KV=cache)
if [ "${VLLM_RUNNING:-0}" -gt 0 ] || [ "${VLLM_WAITING:-0}" -gt 0 ] || [ "${KV_PCT:-0}" -gt 0 ]; then
  if [ -n "$alien_str" ]; then alien_str="${alien_str} "; fi
  vllm_live=$(printf '\033[35mR%sW%s KV%s%%\033[0m' "${VLLM_RUNNING:-0}" "${VLLM_WAITING:-0}" "${KV_PCT:-0}")
  alien_str="${alien_str}${vllm_live}"
fi

# Daily stats (vLLM requests, Embed with latency, Mem0)
daily_parts=""
if [ "${VLLM_DAILY:-0}" -gt 0 ]; then
  daily_parts="vLLM:${VLLM_DAILY}"
fi
if [ "${EMBED_DAILY:-0}" -gt 0 ]; then
  if [ -n "$daily_parts" ]; then daily_parts="${daily_parts} "; fi
  if [ "${EMBED_LATENCY:-0}" -gt 0 ]; then
    daily_parts="${daily_parts}E:${EMBED_DAILY}/${EMBED_LATENCY}ms"
  else
    daily_parts="${daily_parts}E:${EMBED_DAILY}"
  fi
fi
if [ "${MEM0_COUNT:-0}" -gt 0 ]; then
  if [ -n "$daily_parts" ]; then daily_parts="${daily_parts} "; fi
  daily_parts="${daily_parts}M:${MEM0_COUNT}"
fi

if [ -n "$daily_parts" ]; then
  if [ -n "$alien_str" ]; then alien_str="${alien_str} · "; fi
  alien_str="${alien_str}$(printf '\033[35m%s\033[0m' "$daily_parts")"
fi

# Add to status line if we have any alien data
if [ -n "$alien_str" ]; then
  status_line="${status_line} · ${alien_str}"
fi

# Context percentage (at the end)
if [ -n "$ctx_pct" ]; then
  status_line="${status_line} · ${ctx_pct}"
fi

printf '%s' "$status_line"

# ============================================================================
# ACTIVITY LINES (Tools, Agents, Todos) - from claude-hud style helper
# ============================================================================
helper_script="$HOME/.claude/statusline-helper.mjs"
if [ -f "$helper_script" ]; then
  # Run helper (fast - just parses transcript JSONL)
  activity_lines=$(echo "$input" | node "$helper_script" 2>/dev/null)
  if [ -n "$activity_lines" ]; then
    printf '\n%s' "$activity_lines"
  fi
fi
