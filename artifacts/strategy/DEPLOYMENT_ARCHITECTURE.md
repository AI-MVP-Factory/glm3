# SOLO Business Vision - Deployment Architecture

## Overview

This document describes the complete deployment architecture for the SOLO Business Vision platform, a distributed system designed for 24/7 operation across multiple machines. The architecture follows a microservices pattern with centralized monitoring and AI-powered operations.

## Physical Deployment

### Mac (Orchestrator) - 192.168.68.55

**Role**: Primary orchestrator and development environment

**Services Running**:
- **Orchestrator**: Manages MVP operations and coordinates between machines
- **Brain API Client**: Queries the Brain on Alienware for insights
- **opus-router**: GLM API proxy (127.0.0.1:8788) routing requests
- **Development Services**: Local testing and debugging of MVP components

**Why Mac**:
- Primary development environment
- Orchestrates operations across the fleet
- Runs GLM proxy for AI services
- User interaction point for system management

### Alienware (Production) - 192.168.68.58

**Role**: Primary production server hosting core services

**Services Running**:
- **Brain API**: Central knowledge base (192.168.68.58:8080)
- **LiteLLM**: LLM inference gateway (192.168.68.58:4001)
- **Signal Scanner**: MVP opportunity discovery (systemd)
- **Scoring Engine**: AI evaluation system (systemd, port 8100)
- **Ops Agent**: Infrastructure monitoring (systemd)
- **Morning Brief**: Daily report generation (cron)
- **Grafana**: Monitoring dashboard (192.168.68.58:3000)
- **Prometheus**: Metrics collection (192.168.68.58:9090)

**Why Alienware**:
- High-performance AMD Ryzen + RTX 4070
- 24/7 production environment
- Central Brain API hosting
- Integrated monitoring stack

### PC (Research Lab) - 192.168.68.50

**Role**: Research and development node

**Services Running**:
- **Research Workers**: 7 specialized AI workers (supervisorctl)
  - v1_community_worker
  - v2_discord_worker
  - v3_discourse_worker
  - v4_anticipator_worker
  - v5_hackernews_worker
  - v6_github_worker
  - v7_research_worker
- **LiteLLM**: Alternative LLM gateway (192.168.68.50:4000)

**Why PC**:
- Dedicated research infrastructure
- Multiple concurrent AI workers
- Load distribution across fleet
- Research-specific processing

## Service Management

### Systemd Services (Alienware)

| Service | Port | Description | Dependencies |
|---------|------|-------------|--------------|
| signal-scanner | - | Scans sources for MVP opportunities | network.target |
| scoring-engine | 8100 | Evaluates candidates with AI | signal-scanner.service |
| ops-agent | - | Monitors all services | network.target |
| grafana | 3000 | Monitoring dashboard | network.target |
| prometheus | 9090 | Metrics collection | network.target |
| brain-api | 8080 | Central knowledge base | network.target |
| litellm | 4001 | LLM inference gateway | network.target |

### Supervisor Services (PC)

| Service | Process Count | Description |
|---------|---------------|-------------|
| v1_community_worker | 1 | Discord community monitoring |
| v2_discord_worker | 1 | Discord server scanning |
| v3_discourse_worker | 1 | Discourse forum monitoring |
| v4_anticipator_worker | 1 | Future trend analysis |
| v5_hackernews_worker | 1 | Hacker News scanning |
| v6_github_worker | 1 | GitHub repository scanning |
| v7_research_worker | 1 | Deep research tasks |

### Cron Jobs (Alienware)

| Job | Schedule | Description |
|-----|----------|-------------|
| morning-brief | 0 6 * * * | Daily business briefing |

### Docker Containers

Currently no Docker containers are used. All services run natively with systemd/supervisor for direct performance and resource control.

## Configuration Management

### Environment Variables

#### Global Configuration (~/.config/solo/api_key.env)
```bash
SOLO_API_KEY=your_api_key_here
```

#### Service-Specific Configuration

**Signal Scanner (.env)**:
```bash
# Brain API
SOLO_API_KEY=${SOLO_API_KEY}
BRAIN_API_URL=http://192.168.68.58:8080

# External APIs (optional)
REDDIT_CLIENT_ID=${REDDIT_CLIENT_ID:-}
REDDIT_CLIENT_SECRET=${REDDIT_CLIENT_SECRET:-}
TWITTER_BEARER_TOKEN=${TWITTER_BEARER_TOKEN:-}
PRODUCT_HUNT_API_TOKEN=${PRODUCT_HUNT_API_TOKEN:-}
```

**Scoring Engine (.env)**:
```bash
# Brain API
SOLO_API_KEY=${SOLO_API_KEY}
BRAIN_API_URL=http://192.168.68.58:8080

# AI Scoring (via opus-router)
ANTHROPIC_API_KEY=${SOLO_API_KEY}
ANTHROPIC_BASE_URL=http://127.0.0.1:8788/v1
```

**Ops Agent (.env)**:
```bash
# Brain API
BRAIN_API_URL=http://192.168.68.58:8080
SOLO_API_KEY=${SOLO_API_KEY}

# AI Diagnosis (via opus-router)
ANTHROPIC_API_KEY=${SOLO_API_KEY}
ANTHROPIC_BASE_URL=http://127.0.0.1:8788/v1

# Email Alerts (optional)
OPS_AGENT_EMAIL_ENABLED=false
OPS_AGENT_EMAIL_TO=founder@example.com
OPS_AGENT_EMAIL_FROM=ops@example.com
OPS_AGENT_SMTP_SERVER=smtp.gmail.com
OPS_AGENT_SMTP_PORT=587
OPS_AGENT_SMTP_USER=your@email.com
OPS_AGENT_SMTP_PASSWORD=your_app_password

# Check interval
OPS_AGENT_CHECK_INTERVAL=60
```

**Shared API Keys (/home/p/dev/mvps/services/.api-keys)**:
Auto-generated during deployment containing all API keys for services.

### Configuration Files

**Scoring Engine (config.py)**:
```python
# Scoring weights
WEIGHTS = {
    "market": 0.25,
    "competition": 0.20,
    "emotional": 0.30,
    "feasibility": 0.15,
    "signal_quality": 0.10,
}

# Thresholds
EMOTIONAL_PASS_THRESHOLD = 96.0
OVERALL_GO_THRESHOLD = 85.0
OVERALL_RESEARCH_THRESHOLD = 70.0
```

**Ops Agent (runbook/runbook.yaml)**:
Contains common issues and auto-resolution steps.

**Morning Brief (config.py)**:
Configuration for report generation thresholds and data sources.

## Deployment Script

The `deploy-all-services.sh` script automates deployment of all 5 core services to Alienware:

### Script Features

1. **Pre-deployment Checks**:
   - SSH connectivity verification
   - Directory structure creation
   - API key validation

2. **Configuration Management**:
   - Syncs API keys from Mac to Alienware
   - Creates service-specific .env files
   - Sets up shared configuration

3. **Service Deployment**:
   - Signal Scanner: MVP opportunity discovery
   - Scoring Engine: AI candidate evaluation (port 8100)
   - Ops Agent: Infrastructure monitoring
   - Morning Brief: Daily cron job (6:00 AM)
   - Dashboard: Grafana monitoring (port 3000)

4. **Post-deployment**:
   - Enables and starts systemd services
   - Verifies service status
   - Provides usage commands

### Usage

```bash
# Deploy all services
./deploy-all-services.sh

# Check service status
ssh alien 'systemctl status signal-scanner scoring-engine ops-agent'

# View logs
ssh alien 'journalctl -u signal-scanner -f'
```

### Configuration Requirements

**Required API Keys**:
- `SOLO_API_KEY`: Brain API access
- `ANTHROPIC_API_KEY`: AI scoring (via opus-router)

**Optional API Keys** (for full functionality):
- `REDDIT_CLIENT_ID`, `REDDIT_CLIENT_SECRET`
- `TWITTER_BEARER_TOKEN`
- `PRODUCT_HUNT_API_TOKEN`

### Service Dependencies

```
signal-scanner ────▶ scoring-engine
       │
       ▼
    Morning Brief (cron)

Ops Agent ────────▶ All services
       │
       ▶ Brain API
```

## Monitoring and Observability

### Health Checks

- **Brain API**: `http://192.168.68.58:8080/health`
- **Scoring Engine**: `http://localhost:8100/health`
- **Grafana**: `http://192.168.68.58:3000/api/health`
- **Prometheus**: `http://192.168.68.58:9090/-/healthy`
- **LiteLLM**: `http://192.168.68.58:4001/health`

### Log Locations

- **Systemd Logs**: `journalctl -u <service>`
- **Service Logs**: Service-specific directories
- **Cron Logs**: `/var/log/syslog` (cron jobs)
- **Morning Brief**: `logs/YYYY-MM-DD.log`

### Metrics Collection

Prometheus scrapes metrics from:
- All systemd services
- Worker processes
- Resource usage (CPU, memory, disk)
- API response times
- Error rates

## Security Considerations

1. **API Key Management**:
   - Keys stored in `~/.config/solo/api_key.env` (chmod 600)
   - Environment variable injection in production
   - Regular key rotation

2. **Network Security**:
   - Services listen on localhost/127.0.0.1 where possible
   - Firewall rules restrict external access
   - SSH keys for machine-to-machine communication

3. **Access Control**:
   - User `p` for service execution
   - sudo for systemd service management
   - SSH access limited to fleet machines

## Backup and Recovery

1. **Configuration Backup**:
   - Git repository stores all configs
   - API keys backed up separately

2. **Service Recovery**:
   - systemd restarts failed services automatically
   - Ops Agent monitors and auto-resolves common issues
   - Regular health checks trigger alerts

3. **Data Backup**:
   - Brain API data persists in LanceDB
   - Service logs rotated regularly
   - Critical data version controlled

## Scaling Considerations

### Horizontal Scaling

- Workers can be added to PC via supervisor
- Multiple scoring engine instances possible
- Load balancer for API services

### Vertical Scaling

- Resource monitoring prevents overloading
- Auto-scaling based on metrics planned
- Database optimization for Brain API

## Troubleshooting

### Common Commands

```bash
# Check all services
ssh alien 'systemctl status'

# View specific service logs
ssh alien 'journalctl -u signal-scanner -f'

# Test service connectivity
curl http://192.168.68.58:8080/health

# Restart service
ssh alien 'sudo systemctl restart signal-scanner'

# Check worker status
ssh pc 'supervisorctl status'
```

### Known Issues

1. **Service Dependencies**: Ops Agent depends on Brain API availability
2. **Memory Usage**: Workers consume significant RAM during processing
3. **Disk Space**: Regular log rotation needed for long-term operation

## Maintenance Schedule

- **Daily**: Service health checks, log review
- **Weekly**: Performance metrics analysis
- **Monthly**: Configuration review, key rotation
- **Quarterly**: System updates, security patches

---

*Document generated on: 2026-01-29*
*Version: 1.0*
