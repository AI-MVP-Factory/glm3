# GLM3 Failure Recovery Plan

> **Created:** January 29, 2026  
> **Status:** ACTIVE  
> **Document:** FAILURE_RECOVERY.md  
> **Scope:** Comprehensive failure modes and recovery procedures for GLM3 system

---

## Table of Contents

1. [Failure Modes](#failure-modes)
   - Service Crashes
   - Network Failures
   - Resource Exhaustion
   - API Rate Limits
   - Brain API Failures
   - opus-router Failures

2. [Auto-Recovery](#auto-recovery)
   - Ops Agent Runbook (12+ Issue Types)
   - systemd Service Management
   - Retry Logic & Circuit Breakers

3. [Manual Recovery](#manual-recovery)
   - Data Recovery Procedures
   - Service Reinstallation
   - Key Rotation & Secrets Management

4. [Disaster Recovery](#disaster-recovery)
   - Worst Case Scenarios
   - Complete System Rebuild
   - Business Continuity Plans

---

## Failure Modes

### Service Crashes

| Service | Failure Symptoms | Auto-Recovery | Manual Recovery |
|---------|------------------|---------------|----------------|
| **Brain API** | HTTP 503, slow responses, LanceDB errors | Restart → Clear cache → Rebuild index | Restore from backup → Recreate database |
| **LiteLLM** | Model routing failures, 502 errors | Restart container → Recreate service | Reinstall Docker compose → Rotate API keys |
| **Grafana** | Dashboard errors, API unreachable | Restart service → Check port 3000 | Rebuild containers → Restore configs |
| **Prometheus** | Metrics collection failures | Restart service → Check exporters | Reset data → Reconfigure targets |
| **Workers** | High CPU, stuck loops, dead processes | Supervisor restart → Kill stuck tasks | Supervisor reinstall → Code deployment |

### Network Failures

| Issue | Symptoms | Auto-Recovery | Impact |
|-------|----------|---------------|--------|
| **LAN Connectivity Loss** | Ping failures, SSH timeouts | Check router → Wake-on-LAN alert | Complete system isolation |
| **Meshnet Issues** | `ssh o` failures, OR access | Wait for recovery → Meshnet restart | Backup systems affected |
| **DNS Resolution** | Service name resolution fails | systemd-resolved restart | All service connections |
| **Firewall Blocking** | Port access denied | Check UFW rules → Temporarily disable | Security perimeter breach |

### Resource Exhaustion

#### Memory Issues
```yaml
oom_killer_detected:
  symptoms:
    - "kernel_log contains 'Out of memory'"
    - "kernel_log contains 'Kill process'"
  auto_resolve:
    - "Find killed process: journalctl -k | grep -i 'out of memory'"
    - "Restart affected service: systemctl restart brain-api"
    - "Clear cache: sync && echo 3 > /proc/sys/vm/drop_caches"
  escalation:
    - if: "oom_count > 3 in 1 hour" → immediate_alert
    - if: "killed_process == brain-api" → alert_founder
```

#### Disk Space Critical
```yaml
disk_space_critical:
  threshold: 90%
  auto_resolve:
    - "Vacuum journals: journalctl --vacuum-time=3d"
    - "Clean Docker: docker system prune -f --volumes"
    - "Clean worker outputs: find /var/oled/mvps/worker_output -mtime +7 -delete"
    - "Clean Brain snapshots: find /var/oled/brain/snapshots -mtime +30 -delete"
  escalation:
    - > 90%: immediate_alert
    - > 95%: manual cleanup required
    - > 98%: EMERGENCY alert
```

#### CPU Usage
```yaml
high_cpu_usage:
  threshold: 90% for 10 minutes
  auto_resolve:
    - "Identify processes: ps aux --sort=-%cpu | head -10"
    - "Check for runaway: top -b -n 1 | head -20"
    - "Restart Brain API (common culprit): systemctl restart brain-api"
  escalation:
    - > 98% for 30min: alert_founder
```

### API Rate Limits

| Provider | Limit | Auto-Recovery | Manual Action |
|----------|-------|---------------|---------------|
| **Anthropic Claude** | 100 RPM → 200 RPM | Backoff + retry → Circuit breaker | Scale requests → Monitor usage |
| **OpenAI** | 3500 RPM → 9000 RPM | Exponential backoff → Switch models | Upgrade tier → Request increase |
| **Z.AI (GLM)** | 2000 RPM → 4000 RPM | Rate limiting → Queue requests | Contact support → Scale vertically |

### Brain API Failures

#### High Memory Usage
```yaml
brain_api_high_memory:
  threshold: 90%
  auto_resolve:
    - "Graceful restart: systemctl restart brain-api"
    - "Force restart: pkill -f brain-api && systemctl start brain-api"
  escalation:
    - > 98%: OOM imminent alert
```

#### LanceDB Corruption
```yaml
brain_lancedb_corruption:
  symptoms:
    - "LanceTableNotFound in logs"
    - "corruption in brain_api_log"
  auto_resolve:
    - "Backup database: cp -r /var/oled/brain/lancedb /var/oled/brain/lancedb_backup"
    - "Restart API: systemctl restart brain-api"
  escalation:
    - "Recovery failed" → immediate_alert
    - "Data loss detected" → critical_alert
```

### opus-router Failures

| Issue | Symptoms | Recovery |
|-------|----------|----------|
| **Proxy Service Down** | GLM requests fail, 502 errors | Check: `curl http://127.0.0.1:8788/health` |
| **Port Conflict** | Address already in use | Kill process: `pkill -f opus-router` |
| **Authentication Fail** | GLM API 401 | Check OAuth tokens → Re-authenticate |
| **Memory Leak** | Growing RAM usage | Restart service → Monitor usage |

---

## Auto-Recovery

### Ops Agent Runbook (12+ Issue Types)

The Ops Agent continuously monitors and auto-resolves common issues:

1. **Worker Stopped Responding**
   - Restart via supervisorctl → systemctl fallback
   - Alert if > 3 restarts in 1 hour

2. **Brain API High Memory**
   - Graceful restart → Force restart
   - Immediate alert if > 98%

3. **Disk Space Critical**
   - Vacuum logs → Clean Docker → Clean outputs → Clean snapshots
   - Progressive escalation at 90/95/98%

4. **LiteLLM Unresponsive**
   - Container restart → Recreate from compose
   - Alert after 10 minutes

5. **Grafana/Prometheus Unresponsive**
   - Service restart → Container restart fallback
   - Log only for monitoring gaps

6. **High CPU Usage**
   - Identify processes → Check for runaway → Restart API
   - Alert after sustained high usage

7. **OOM Killer Detected**
   - Find killed process → Restart service → Clear cache
   - Multiple OOMs → Memory upgrade alert

8. **Network Connectivity Loss**
   - Check connectivity → Wake-on-LAN
   - Immediate alert if > 5 minutes

9. **Zombie Processes**
   - Identify parents → Kill to reap zombies
   - Alert if > 100 zombies

10. **Worker Stuck in Loop**
    - Check logs → Graceful restart → Archive large outputs
    - Alert if repeatedly stuck

11. **Brain LanceDB Corruption**
    - Backup database → Restart → Recovery check
    - Critical alert on data loss

12. **Global Escalations**
    - Revenue drop > 20% → immediate_alert
    - App store rejection → critical_alert
    - Security incident → immediate_alert
    - Service down > 10min → alert_founder

### systemd Service Management

All services use systemd with auto-restart:

```ini
# Example: brain-api.service
[Unit]
Description=Brain API Service
After=network.target

[Service]
Type=simple
User=alien
Restart=always
RestartSec=10
EnvironmentFile=/etc/environment
ExecStart=/usr/local/bin/uvicorn brain.api:app --host 0.0.0.0 --port 8080

[Install]
WantedBy=multi-user.target
```

### Retry Logic & Circuit Breakers

- **Exponential Backoff**: For API calls (base 1s, max 60s)
- **Circuit Breaker**: Trip after 5 failures, reset after 2 minutes
- **Health Checks**: 30-second intervals for all services
- **Graceful Degradation**: Fallback to cached responses when down

---

## Manual Recovery

### Data Recovery Procedures

#### Brain LanceDB Recovery
```bash
# 1. Check backup availability
ls -lh /var/oled/brain/snapshots/
ls -lh /home/opc/backups/brain/

# 2. Stop Brain API
ssh alien 'systemctl stop brain-api'

# 3. Restore from backup
scp p@192.168.68.58:/home/p/backups/brain/lancedb-backup-*.tar.gz /tmp/
cd /var/oled/brain
mv lancedb lancedb.broken
tar -xzf /tmp/lancedb-backup-*.tar.gz

# 4. Restart and verify
ssh alien 'systemctl start brain-api'
curl -s http://192.168.68.58:8080/health
```

#### Worker Output Recovery
```bash
# 1. List available archives
ssh alien 'ls -la /var/oled/mvps/worker_output/archive/'

# 2. Restore recent outputs
ssh alien 'cp /var/oled/mvps/worker_output/archive/worker_*_20260129*.tar.gz /var/oled/mvps/worker_output/'

# 3. Extract and validate
ssh alien 'cd /var/oled/mvps/worker_output && tar -xzf worker_*.tar.gz && ls -la'
```

#### Complete Mac Restore
```bash
# 1. Restore from Alienware (latest)
rsync -avz p@192.168.68.58:/home/p/backups/mac-daily/ ~/restore/

# 2. Specific critical folders
rsync -avz p@192.168.68.58:/home/p/backups/mac-daily/claude/ ~/.claude/
rsync -avz p@192.168.68.58:/home/p/backups/mac-daily/ssh/ ~/.ssh/
chmod 700 ~/.ssh && chmod 600 ~/.ssh/*

# 3. Check git status
git status
```

### Service Reinstallation

#### Brain API Fresh Install
```bash
# On Alienware
ssh alien

# 1. Stop and remove
systemctl stop brain-api
rm -rf /var/oled/brain/lancedb

# 2. Clone and install
cd ~ && git clone https://github.com/solo/brain-api.git
cd brain-api
pip install -r requirements.txt

# 3. Initialize database
python -m brain.init_database

# 4. Start and enable
systemctl start brain-api
systemctl enable brain-api

# 5. Verify
curl http://localhost:8080/health
```

#### LiteLLM Reinstall
```bash
# On Alienware
cd ~/dev/litellm
docker-compose down
docker-compose up -d
docker ps | grep litellm
```

### Key Rotation & Secrets Management

#### Key Rotation Procedure
```bash
# 1. Identify all keys
grep -r "API_KEY" ~/.config/solo/
grep -r "secret" ~/.config/solo/

# 2. Rotate in services (example for GLM)
# Generate new key at provider
export NEW_GLM_KEY="new-key-here"

# Update environment
echo "GLM_API_KEY=$NEW_GLM_KEY" >> ~/.config/solo/api_key.env

# Restart dependent services
systemctl restart opus-router
docker-compose restart

# 3. Backup old keys
cp ~/.config/solo/api_key.env ~/.config/solo/rotated_keys_$(date +%Y%m%d).env

# 4. Update documentation
git add ~/.config/solo/ && git commit -m "Rotate API keys $(date +%Y%m%d)"
```

#### Gitleaks Integration
- Pre-commit hooks prevent secret commits
- Automated scanning for exposed keys
- Rotation schedule: Quarterly or after incidents

---

## Disaster Recovery

### Worst Case Scenarios

#### Scenario 1: Alienware Total Failure
**Symptoms**: Complete system unresponsive, hardware failure  
**RTO**: 2 hours  
**Recovery Steps**:
1. **Immediate**: Failover to Oracle Cloud (limited capacity)
2. **Short-term**: Provision new Alienware hardware
3. **Recovery**: Restore from Google Drive + Alienware backups
4. **Verification**: Test all services and worker coordination

#### Scenario 2: Brain Data Loss
**Symptoms**: LanceDB corruption, missing records  
**RTO**: 4 hours  
**Recovery Steps**:
1. **Assess**: Check backup integrity and last known good state
2. **Restore**: Latest complete backup from Google Drive
3. **Rebuild**: Re-index from source documents if needed
4. **Validate**: Query test records across all tables

#### Scenario 3: Complete System Breach
**Symptoms**: Unauthorized access, data exfiltration  
**RTO**: 6 hours  
**Recovery Steps**:
1. **Contain**: Network isolation, credential lockdown
2. **Wipe**: Format all affected systems
3. **Rebuild**: Fresh OS installation from scratch
4. **Restore**: Configs from offline backups only
5. **Audit**: Post-mortem security review

#### Scenario 4: Multi-Site Outage
**Symptoms**: Both Alienware + Oracle Cloud down  
**RTO**: 8 hours  
**Recovery Steps**:
1. **Activate**: Emergency cloud instances
2. **Restore**: Critical services only (Brain API + LiteLLM)
3. **Prioritize**: Worker coordination and MVP system
4. **Rebuild**: Non-essential services later

### Complete System Rebuild

#### Full Mac Rebuild
```bash
# 1. New Mac setup
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install rclone git python@3.11 uv go

# 2. Configure rclone
rclone config  # peter@belio.co

# 3. Restore critical configs
rclone copy gdrive-solo:SOLO-Backups/mac-critical/ /tmp/
cd /tmp && tar -xzf mac-critical-*.tar.gz
cp -r .claude/ ~/.claude/ && cp -r .ssh/ ~/.ssh/
chmod 700 ~/.ssh && chmod 600 ~/.ssh/*

# 4. Full backup from Alienware
rsync -avz p@192.168.68.58:/home/p/backups/mac-daily/ ~/

# 5. Install services
cd ~/dev/opus-router && make install
cd ~/dev/worktree-manager && make install
```

#### Full Alienware Rebuild
```bash
# 1. Ubuntu 22.04 installation
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io docker-compose git python3-pip rclone

# 2. Docker setup
sudo usermod -aG docker $USER
newgrp docker

# 3. Restore configs from Google Drive
rclone copy gdrive:SOLO-Backups/alienware-configs/ /tmp/
cd /tmp && tar -xzf alien-configs-*.tar.gz
cp -r .ssh/ ~/.ssh/ && cp -r solo-config/ ~/solo-config/

# 4. Install services
git clone https://github.com/solo/litellm.git ~/dev/litellm
git clone https://github.com/solo/brain-api.git ~/dev/brain-api
cd ~/dev/litellm && docker-compose up -d
```

### Business Continuity Plans

#### MVP System Minimal Viable
**Components**: Brain API only (workers via Mac)  
**RTO**: 30 minutes  
**Capacity**: 10 concurrent workers  

#### Reduced Functionality Mode
**Components**: Brain API + LiteLLM (no monitoring)  
**RTO**: 1 hour  
**Capacity**: 50% normal  

#### Zero Downtime Migration
- Use Kubernetes for live migration
- Multi-region deployment setup
- Automated failover procedures

---

## Monitoring & Alerting

### Health Check Endpoints
```bash
# Brain API
curl http://192.168.68.58:8080/health

# LiteLLM
curl http://192.168.68.58:4001/health

# Grafana
curl http://192.168.68.58:3000/api/health

# Prometheus
curl http://192.168.68.58:9090/-/healthy

# opus-router
curl http://127.0.0.1:8788/health
```

### Critical Metrics to Monitor
- Memory usage (alert > 90%)
- Disk space (alert > 85%)
- CPU usage (alert > 80% sustained)
- Response times (alert > 2s average)
- Error rates (alert > 1%)
- Worker queue depth (alert > 100)

### Contact Information
- **Primary**: petr.chalupnik@gmail.com
- **Oracle Console**: https://cloud.oracle.com
- **Emergency**: peter@belio.co
- **Slack**: SOLO ops channel

---

## Testing & Validation

### Regular Testing Schedule
- **Weekly**: Service restarts
- **Monthly**: Full recovery drills
- **Quarterly**: Disaster scenarios
- **After changes**: New procedures tested

### Test Scenarios
1. **Simulated OOM**: Trigger memory limits
2. **Disk Full**: Fill partitions to 95%
3. **Network Partition**: Disconnect services
4. **API Failure**: Rate limit simulation
5. **Worker Crash**: Force supervisor kills

### Validation Commands
```bash
# Check all services
ssh alien 'systemctl status brain-api litellm grafana prometheus'

# Verify backups
rclone ls gdrive-solo:SOLO-Backups/
ssh alien 'du -sh /home/p/backups/*'

# Test connectivity
ping -c 3 192.168.68.58
curl -s http://192.168.68.58:8080/entities -d '{"query":"test"}'
```

---

*Document Version: 1.0*  
*Last Updated: January 29, 2026*  
*Next Review: February 29, 2026*
