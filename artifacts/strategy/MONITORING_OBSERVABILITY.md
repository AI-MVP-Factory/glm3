# GLM3 Monitoring & Observability Architecture

## Overview

This document provides a comprehensive overview of the monitoring and observability infrastructure for the GLM3 project, including Prometheus metrics, Grafana dashboards, logging configurations, health checks, and alerting rules.

## Table of Contents

1. [Prometheus Metrics](#prometheus-metrics)
2. [Grafana Dashboards](#grafana-dashboards)
3. [Logging Infrastructure](#logging-infrastructure)
4. [Health Checks](#health-checks)
5. [Alerting Rules](#alerting-rules)
6. [Monitoring Stack Components](#monitoring-stack-components)
7. [Operational Workflows](#operational-workflows)

## Prometheus Metrics

### Global Configuration

```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
```

### Scraped Metrics Endpoints

#### 1. Node Exporter Metrics
- **Alienware**: `localhost:9100`
- **PC**: `192.168.68.50:9100`
- **Metrics**: CPU, memory, disk, network

#### 2. GPU Metrics
- **Location**: `localhost:9400` (Alienware only)
- **Metrics**: GPU temperature, usage, memory

#### 3. Brain V3 Worker Exporter
- **Alienware**: `localhost:9403`
- **PC**: `192.168.68.50:9403`
- **Key Metrics**:
  - `brain_worker_status`: Worker status (0=down, 1=up)
  - `brain_worker_memory_bytes`: Memory usage
  - `brain_worker_restart_count`: Restart count
  - `brain_worker_uptime_seconds`: Uptime

#### 4. LanceDB Metrics
- **Location**: `localhost:9105`
- **Key Metrics**:
  - `brain_lancedb_rows_total`: Total records
  - `brain_lancedb_size_bytes`: Database size
  - `brain_lancedb_ingestion_rate`: Records/second

#### 5. LiteLLM Metrics
- **Location**: `localhost:9101`
- **Key Metrics**:
  - Model usage statistics
  - Request latency
  - Error rates

#### 6. LiteLLM Usage Exporter
- **Location**: `localhost:9102`
- **Metrics**: Detailed usage from database

#### 7. Hive Swarm Metrics
- **Location**: `localhost:8789`
- **Metrics**: Task queue, worker status, throughput

#### 8. Opus Router Metrics
- **Location**: `192.168.68.54:8788`
- **Metrics**: API calls, latency, error rates

#### 9. Pushgateway
- **Location**: `localhost:9091`
- **Purpose**: WSL2 workaround for PC metrics

#### 10. Prometheus Self-Monitoring
- **Location**: `localhost:9090`
- **Metrics**: Scrape metrics, storage, query performance

### Metric Categories

#### System Metrics
- `node_cpu_seconds_total`: CPU usage
- `node_memory_MemAvailable_bytes`: Available memory
- `node_memory_MemTotal_bytes`: Total memory
- `node_filesystem_avail_bytes`: Disk space
- `node_load1`, `node_load5`, `node_load15`: Load averages

#### Application Metrics
- `brain_worker_*`: Worker-specific metrics
- `brain_signal_queue_*`: Queue metrics
- `brain_lancedb_*`: Database metrics
- `litellm_*`: Model server metrics
- `hive_swarm_*`: Task orchestration metrics

#### Business Metrics
- Revenue tracking
- User engagement
- Service availability
- Error rates by service

## Grafana Dashboards

### Available Dashboards

#### 1. Business Overview
- **File**: `/var/lib/grafana/dashboards/business-overview.json`
- **Purpose**: High-level business metrics
- **Key Panels**:
  - Revenue trends
  - User activity
  - Service health summary

#### 2. Hive Swarm Dashboard
- **File**: `/var/lib/grafana/dashboards/hive-swarm-dashboard.json`
- **Purpose**: Task orchestration monitoring
- **Key Panels**:
  - Task queue status
  - Worker utilization
  - Task completion rates
  - Error rates

#### 3. Brain Intelligence Dashboard
- **File**: `/var/lib/grafana/dashboards/brain-intelligence.json`
- **Purpose**: Brain API and database monitoring
- **Key Panels**:
  - LanceDB record count
  - API latency
  - Memory usage
  - Query patterns

#### 4. System Infrastructure Dashboard
- **Automatically generated** from Prometheus
- **Key Panels**:
  - Node metrics (CPU, memory, disk)
  - Network traffic
  - GPU metrics

#### 5. Alert Dashboard
- **Purpose**: Current and historical alerts
- **Key Panels**:
  - Active alerts
  - Alert history
  - Alert severity distribution

### Data Sources

#### Prometheus
```yaml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: true
    editable: true
```

### Dashboard Provenance

Grafana is configured with dashboard provisioning:
- **Location**: `/etc/grafana/provisioning/dashboards/`
- **Configuration**: `solo.yaml`
- **Auto-imports dashboards** from `/var/lib/grafana/dashboards/`

## Logging Infrastructure

### Structured Logging Configuration

#### Python Applications
```python
# Standard configuration for GLM3 applications
import structlog
from rich.console import Console
from rich.logging import RichHandler

console = Console()
logger = structlog.get_logger()
```

#### Log Locations

##### Alienware
- **Brain API**: `/var/log/brain-api.log`
- **Workers**: `/var/log/supervisor/`
- **System**: `/var/log/syslog`
- **Application logs**: `/var/log/mvps/`

##### PC
- **Research logs**: `/home/p/dev/research/logs/`
- **System logs**: `/var/log/syslog`

#### Log Rotation

##### System Logs
- Managed by `logrotate`
- Configuration: `/etc/logrotate.conf`
- Daily rotation with 7-day retention

##### Application Logs
- Size-based rotation (100MB max)
- 10 file history
- Compressed archives

#### Log Levels

| Level | Purpose |
|-------|---------|
| DEBUG | Detailed debugging information |
| INFO | General operational information |
| WARNING | Warning conditions |
| ERROR | Error conditions |
| CRITICAL | Critical errors |

#### Structured Log Fields

All logs include structured fields:
```json
{
  "timestamp": "2026-01-29T12:00:00Z",
  "level": "INFO",
  "service": "brain-api",
  "request_id": "req_123",
  "user_id": "user_456",
  "message": "Query processed successfully",
  "duration_ms": 45,
  "error": null
}
```

### Centralized Logging

#### Fluentd/Logstash Configuration
- **Not yet implemented** - planned for future
- **Target**: Elasticsearch cluster
- **RetentionPolicy**: 30 days

### Log Analysis

#### Key Log Patterns
- Worker startup/shutdown events
- API latency outliers
- Error rate spikes
- Memory usage patterns
- Database query performance

## Health Checks

### Service Health Endpoints

#### 1. Brain API
```bash
curl http://192.168.68.58:8080/health
```
**Response**:
```json
{
  "status": "healthy",
  "version": "3.0.0",
  "database": "connected",
  "uptime": "2h 30m",
  "memory_usage": "45%"
}
```

#### 2. Prometheus
```bash
curl http://192.168.68.58:9090/-/healthy
```

#### 3. Grafana
```bash
curl http://192.168.68.58:3000/api/health
```

#### 4. LiteLLM
```bash
curl http://192.168.68.58:4001/health
```

#### 5. Node Exporter
```bash
curl http://192.168.68.58:9100/metrics
```

### Worker Health Checks

#### Status Monitoring
- **Supervisor**: `supervisorctl status worker_*`
- **Metrics**: `brain_worker_status` metric
- **Heartbeat**: Every 30 seconds

#### Process Health
```python
# Worker health check implementation
def check_worker_health(worker_name):
    try:
        status = subprocess.run(
            ["supervisorctl", "status", worker_name],
            capture_output=True, text=True
        )
        return "RUNNING" in status.stdout
    except:
        return False
```

### Database Health

#### LanceDB
- Connection tests
- Query performance
- Disk space checks
- Index health

#### PostgreSQL (if used)
- Connection pool status
- Query performance
- Table sizes
- Vacuum progress

### Network Health

#### Connectivity Checks
- Ping tests between nodes
- Port availability
- Latency monitoring
- Bandwidth utilization

### Custom Health Indicators

#### Service Dependencies
- API availability
- Database connectivity
- External service status
- Cache performance

#### Business Health
- Queue processing rates
- Error rates
- Response times
- Resource utilization

## Alerting Rules

### Alert Severity Levels

| Severity | Response Time | Escalation |
|----------|---------------|------------|
| CRITICAL | 15 minutes | Immediate alert to founder |
| HIGH | 30 minutes | Alert to ops team |
| WARNING | 1 hour | Log for review |
| INFO | 24 hours | Informational only |

### Alert Categories

#### 1. Worker Alerts
```yaml
# WorkerDown
alert: WorkerDown
expr: brain_worker_status == 0
for: 2m
labels:
  severity: critical
annotations:
  summary: "Worker {{ $labels.worker }} on {{ $labels.machine }} is down"
  description: "Worker has been stopped for more than 2 minutes"
```

#### 2. Queue Alerts
```yaml
# SignalQueueBacklog
alert: SignalQueueBacklog
expr: brain_signal_queue_total{status="pending"} > 2000
for: 30m
labels:
  severity: warning
annotations:
  summary: "Signal queue has >2000 pending items"
  description: "Current pending: {{ $value }}"
```

#### 3. System Alerts
```yaml
# HighCPULoad
alert: HighCPULoad
expr: node_load15 > 12
for: 10m
labels:
  severity: warning
annotations:
  summary: "{{ $labels.machine }} 15-min load average above 12"
```

#### 4. Memory Alerts
```yaml
# WorkerHighMemory
alert: WorkerHighMemory
expr: brain_worker_memory_bytes > 4294967296
for: 5m
labels:
  severity: warning
annotations:
  summary: "Worker {{ $labels.worker }} using >4GB memory"
  description: "Memory usage: {{ $value | humanize1024 }}"
```

#### 5. Database Alerts
```yaml
# LanceDBStagnant
alert: LanceDBStagnant
expr: increase(brain_lancedb_rows_total[2h]) == 0
for: 2h
labels:
  severity: info
annotations:
  summary: "No new records ingested to Brain in 2 hours"
```

### Escalation Rules

#### Global Escalation
```yaml
global_escalation_rules:
  - name: "revenue_drop"
    condition: "revenue_drop_percent > 20"
    action: "immediate_alert"
    message: "🚨 CRITICAL: Revenue dropped {revenue_drop_percent}%"
  
  - name: "security_incident"
    condition: "security anomaly detected"
    action: "immediate_alert"
    message: "🚨 SECURITY INCIDENT: {incident_type} detected"
```

#### Notification Channels
- **Slack**: #alerts channel
- **Email**: ops-team@example.com
- **PagerDuty**: Critical alerts only
- **Custom Webhook**: Internal alert system

### Alert Management

#### Suppression
- Maintenance windows
- Known issues
- False positive patterns

### Alert Templates

#### Critical Alert
```
🚨 CRITICAL: [Service] - [Issue]
- Duration: [time]
- Impact: [severity]
- Action: [resolution_step]
```

#### Warning Alert
```
⚠️ WARNING: [Service] - [Issue]
- Duration: [time]
- Status: [monitoring]
- Action: [recommended_step]
```

## Monitoring Stack Components

### Prometheus
- **Version**: 2.45.0
- **Retention**: 15 days
- **Storage**: Local disk
- **Configuration**: `/etc/prometheus/prometheus.yml`

### Grafana
- **Version**: 10.2.0
- **Data Source**: Prometheus
- **Admin User**: admin/soloadmin
- **URL**: http://192.168.68.58:3000

### Node Exporter
- **Version**: 1.6.1
- **Metrics**: System metrics
- **Installation**: System service

### Custom Exporters
- **Brain V3 Worker Exporter**: Custom metrics for workers
- **LiteLLM Exporter**: Model server metrics
- **Hive Swarm Exporter**: Task orchestration metrics

## Operational Workflows

### Daily Checks
1. Review Grafana dashboards for anomalies
2. Check alert dashboard for active alerts
3. Verify system resources (CPU, memory, disk)
4. Review application logs for errors

### Weekly Maintenance
1. Review alert effectiveness
2. Update alert thresholds based on trends
3. Clean up old metrics and logs
4. Verify backup of monitoring data

### Incident Response
1. Acknowledge alerts within 5 minutes
2. Check related metrics and logs
3. Execute auto-resolution if available
4. Escalate if not resolved within SLA
5. Document incident in post-mortem

### Performance Tuning
1. Identify bottlenecks from metrics
2. Adjust resource allocations
3. Optimize queries
4. Scale services as needed

### Monitoring Improvements
1. Collect feedback from team
2. Implement new metrics based on requirements
3. Enhance dashboards for better visibility
4. Automate more alerting rules

## Troubleshooting Common Issues

### Prometheus Not Scraping
1. Check service status
2. Verify firewall rules
3. Check scrape configuration
4. Review service logs

### Grafana Not Displaying Data
1. Check Prometheus connectivity
2. Verify datasource configuration
3. Check for syntax errors
4. Review browser console for errors

### Alerts Firing Incorrectly
1. Review alert rules
2. Check metric patterns
3. Adjust thresholds
4. Verify alert condition timing

### High Memory Usage
1. Check top consumers
2. Review application logs
3. Implement auto-restart if configured
4. Increase system resources if needed

## Integration Points

### External Services
- **Alienware**: Primary monitoring host
- **PC**: Secondary metrics collection
- **Mac**: Alert notification
- **Cloud**: Optional backup storage

### CI/CD Integration
- Metrics collection in tests
- Performance benchmarks
- Alert threshold validation
- Deployment impact analysis

### API Integration
- Health check endpoints
- Metrics API
- Alert webhook
- Status reporting

## Future Enhancements

### Planned Improvements
1. **Alertmanager Integration**
   - Centralized alert routing
   - Grouping and inhibition
   - Silencing capabilities

2. **Long-term Storage**
   - VictoriaMetrics or Thanos
   - 1+ year retention
   - Data compression

3. **Distributed Tracing**
   - Jaeger integration
   - Request tracing
   - Performance profiling

4. **Machine Learning**
   - Anomaly detection
   - Predictive alerts
   - Capacity planning

5. **Visualization Enhancements**
   - Real-time dashboards
   - Interactive exploration
   - Custom visualizations

### Documentation Updates
- Regular review and updates
- New feature documentation
- Best practices guide
- Troubleshooting manual

---

*Last Updated: January 29, 2026*
*Version: 1.0*
*Maintainer: GLM3 Operations Team*
