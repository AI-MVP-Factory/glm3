# SPEC 04: Ops AI Agent
**Priority:** MEDIUM
**Estimated Effort:** 3 days
**Worker:** glm6 (design experience - can pivot)

---

## OBJECTIVE
Build an AI agent that automatically resolves operational issues, escalating only critical decisions to the founder.

## DELIVERABLES

### 1. Ops Agent Service
- Location: `/Users/p/dev/mvps/services/ops-agent/`
- Python + Claude API (GLM-4.7 via opus-router)
- Runs 24/7, monitoring all services

### 2. Knowledge Base
- Common issues and solutions
- Runbook for escalation criteria
- Location: `/Users/p/dev/mvps/services/ops-agent/runbook.yaml`

### 3. Action Capabilities
- Restart services
- Clear caches
- Rotate logs
- Send alerts
- Execute safe recovery commands

## MONITORED SERVICES

| Service | Health Check | Auto-Resolve |
|---------|--------------|--------------|
| Brain API | `curl http://192.168.68.58:8080/health` | Restart service |
| Workers (x7) | Check process status | Restart worker |
| LiteLLM | `curl http://192.168.68.58:4001/health` | Restart service |
| Grafana | `curl http://192.168.68.58:3000/api/health` | Restart service |
| Prometheus | `curl http://192.168.68.58:9090/-/healthy` | Restart service |
| Disk Space | `df -h` threshold 90% | Clear logs, alert |
| Memory | `free -m` threshold 90% | Restart heavy services |

## ESCALATION CRITERIA (ALWAYS NOTIFY FOUNDER)

| Condition | Action |
|-----------|--------|
| Revenue drop >20% (hourly) | 🚨 IMMEDIATE ALERT |
| App rejection from App Store | 🚨 IMMEDIATE ALERT |
| Security incident detected | 🚨 IMMEDIATE ALERT |
| Service down >10 minutes | 🚨 ALERT |
| Disk space >95% | ⚠️ WARNING |
| Worker crash >3 times in 1 hour | ⚠️ WARNING |
| Unknown error pattern | 📥 LOG + INVESTIGATE |

## AGENT ARCHITECTURE

```python
# ops-agent/agent.py
class OpsAgent:
    def monitor_all_services() -> HealthReport
        # Check all services
        # Return health status

    def diagnose(issue: Issue) -> Diagnosis
        # Use AI to understand the problem
        # Query Brain for similar past issues
        # Return: diagnosis + suggested action

    def attempt_resolve(issue: Issue) -> ActionResult
        # Try auto-resolution based on runbook
        # Return: success/failure + details

    def should_escalate(issue: Issue) -> bool
        # Check escalation criteria
        # Return: True if founder needs to know

    def escalate(issue: Issue, action_taken: str)
        # Send alert to founder
        # Log for review

    def learn_from_resolution(issue: Issue, resolution: str)
        # Store in Brain for future
        # Update runbook if new pattern
```

## RUNBOOK FORMAT

```yaml
# ops-agent/runbook.yaml
common_issues:
  - name: "Worker stopped responding"
    symptoms:
      - worker_process_status == "dead"
      - last_heartbeat > 5 minutes
    auto_resolve:
      - command: "ssh pc 'supervisorctl restart worker_{name}'"
      - wait: 30
      - verify: "check worker heartbeat"

  - name: "Brain API high memory"
    symptoms:
      - memory_usage > 90%
      - service == "brain-api"
    auto_resolve:
      - command: "ssh alien 'systemctl restart brain-api'"
      - wait: 10
      - verify: "curl health endpoint"

  - name: "Disk space critical"
    symptoms:
      - disk_usage > 90%
    auto_resolve:
      - command: "ssh alien 'journalctl --vacuum-time=3d'"
      - command: "ssh alien 'docker system prune -f'"
      - alert_if: disk_usage > 95%
```

## ALERT FORMATS

```
🚨 CRITICAL: Revenue dropped 25%
Time: 2026-01-29 14:30
Current: $1,837 MRR (was $2,450)
Auto-action: Checking recent events, no app issues detected
👉 ACTION REQUIRED: Investigate manually

---

⚠️ WARNING: Disk space at 92%
Time: 2026-01-29 14:30
Auto-action: Cleared 3GB of old logs
Disk now: 89%
👉 No action needed, monitoring
```

## ACCEPTANCE CRITERIA
- [ ] Monitors all 6+ services automatically
- [ ] Auto-resolves common issues (>80% of issues)
- [ ] Escalates only when appropriate
- [ ] Logs all actions for review
- [ ] Learns from resolutions (updates Brain)
- [ ] Sends alerts via chosen channel (email/push)

## OUTPUT
Service code in: `/Users/p/dev/mvps/services/ops-agent/`
Runbook with 10+ common issues
Test recovery scenarios
Monitoring integration

## BONUS
- Web UI for ops history
- Slack/Telegram bot for alerts
- Predictive alerts (warn before failure)
