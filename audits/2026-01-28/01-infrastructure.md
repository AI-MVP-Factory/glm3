# Infrastructure Audit - 2026-01-28

## Mac (192.168.68.55) - Orchestrator

### System Info
- **OS**: macOS 26.2 (Darwin 25.2.0)
- **Arch**: ARM64 (Apple Silicon)
- **Role**: Primary orchestrator, CLI operations

### Services
| Service | Port | Status | Uptime |
|---------|------|--------|--------|
| opus-router | 8788 | ✅ Healthy | Running |
| GLM-4.7-0419 | - | ✅ Available | Via proxy |

### Directory Structure
```
~/dev/
├── glm3/           # Current project
├── mvps/           # MVP Factory system
├── AI-factory/     # Templates, packages, kits (22 items)
├── opus-router/    # GLM proxy service
└── worktree-manager/ # Git worktree pool manager
```

---

## Alienware (192.168.68.58) - Brain Host

### Services Status
| Service | Port | Status | Uptime | Resources |
|---------|------|--------|--------|-----------|
| Brain API | 8080 | ✅ Healthy | 19h | 39GB RAM |
| Qwen3-VL-Embedding | 8002 | ✅ Up | 40h | Docker |
| Qwen3-VL-Reranker | 8003 | ✅ Up | 40h | Docker |
| LiteLLM | 4001 | ✅ Up | 3h | Docker |

### Service Details

#### Brain API (8080)
```json
{
  "status": "healthy",
  "version": "3.0.0",
  "uptime": "19h",
  "memory": "39GB"
}
```

#### Embedding Service (8002)
- Container: `qwen3-vl-embedding`
- Status: Up 40 hours
- Health: HTTP 200
- Model: Qwen3-VL-Embedding-2B (2048-dim)

#### Reranker Service (8003)
- Container: `qwen3-vl-reranker`
- Status: Up 40 hours
- Health: HTTP 200
- Model: Qwen3-VL-Reranker-2B (cross-encoder)

#### LiteLLM (4001)
- Container: `litellm`
- Status: Up 3 hours
- Auth: API key required
- Note: vLLM endpoint returning 404, fallback working

### Systemd Service
```ini
[Unit]
Description=Brain API - SOLO Intelligence Layer
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/brain-api
ExecStart=/usr/bin/python3 main.py
Restart=always

[Install]
WantedBy=multi-user.target
```

### Recent Logs (10 min)
```
2026-01-28 17:22:13 - POST /query HTTP/1.1 200 OK
2026-01-28 17:22:18 - GET /metrics HTTP/1.1 200 OK
2026-01-28 17:22:19 - POST /query HTTP/1.1 200 OK
```

---

## PC (192.168.68.50) - Worker Fleet

### System Resources
| Metric | Value |
|--------|-------|
| RAM | 12GB / 23GB (52%) |
| Swap | 18GB / 107GB (17%) |
| Load | 13.85, 13.75, 17.00 |

### Running Processes
| Process | CPU | MEM |
|---------|-----|-----|
| v3_session_worker.py | 0.1% | 0.0% |
| v3_founder_worker.py | 0.0% | 0.0% |
| v3_ingestion_worker.py | 0.0% | 0.0% |

### Note
No systemd services for v3 workers - running as standalone processes.

---

## Network Topology

```
                    ┌─────────────────┐
                    │   Router/Gateway │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
   ┌────▼────┐         ┌────▼────┐         ┌────▼────┐
   │   Mac   │         │ Alienware│        │    PC   │
   │ .68.55  │         │  .68.58 │         │  .68.50 │
   │  WiFi   │         │ Ethernet│         │ Ethernet│
   └─────────┘         └─────────┘         └─────────┘
   Orchestrator        Brain Host         Workers
```

### SSH Configuration
```
pc      -> 192.168.68.50:2222  (LAN)
alien   -> 192.168.68.58       (LAN)
o       -> Oracle via Meshnet
pt      -> PC via Meshnet (fallback)
```

---

## Issues Detected

### Non-Blocking
1. **BGE Reranker Fallback Missing**
   - Error: `No module named 'FlagEmbedding'`
   - Impact: None - using Docker Qwen reranker
   - Fix: `pip install FlagEmbedding` if native fallback needed

2. **vLLM Chat Endpoint 404**
   - Error: `/v1/chat/completions` returns 404
   - Impact: None - fallback to Groq/other providers
   - Fix: Investigate LiteLLM → vLLM routing configuration

---

## Comparison Baseline

This audit establishes baseline metrics for future comparison:

| Metric | This Audit | Previous | Change |
|--------|------------|----------|--------|
| Brain Records | 485,848 | - | Baseline |
| Entities | 21,138 | - | Baseline |
| Brain Uptime | 19h | - | Baseline |
| Worker Load | 13.85 | - | Baseline |
