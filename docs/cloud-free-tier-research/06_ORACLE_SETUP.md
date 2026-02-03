# Oracle Cloud Always Free Setup Guide

> **Purpose:** Configure Oracle Cloud Always Free for data plane, backups, monitoring
> **Difficulty:** Medium
> **Time:** 1-2 hours

---

## Prerequisites

- Oracle Cloud account (free, credit card required for verification)
- Basic familiarity with cloud consoles
- SSH key pair for compute instances

---

## Quick Start

### 1. Create Oracle Cloud Account

```
1. Go to https://www.oracle.com/cloud/free/
2. Click "Try for free"
3. Sign up with email, social, or existing Oracle account
4. Add credit card (for verification only, not charged)
5. Select home region (choose closest to you)
   - Recommended: us-ashburn-1, uk-london-1, eu-frankfurt-1
```

### 2. Verify Always Free Resources

After sign-up, verify your Always Free resources:

```
Dashboard → Always Free Resources
```

You should see:
- 2 AMD compute VMs (1/8 OCPU, 1GB each)
- 4 Arm compute VMs (24GB RAM total)
- 2 Block Volumes (200GB total)
- 10GB Object Storage (Standard)
- 10GB Object Storage (Infrequent Access)
- 10GB Archive Storage
- 2 Autonomous Databases (20GB each)

---

## Architecture Setup

```
┌─────────────────────────────────────────────────────────────────┐
│                    ORACLE CLOUD SETUP                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  COMPUTE (Ampere A1 Arm - 4 OCPU + 24GB RAM)                    │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  VM: solo-brain-dataplane                                  │ │
│  │  ├─ PostgreSQL (user data, metrics)                        │ │
│  │  ├─ Grafana + Prometheus (monitoring)                     │ │
│  │  ├─ Backup orchestrator (cron jobs)                        │ │
│  │  └─ Admin dashboard (Streamlit)                           │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  STORAGE                                                         │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Block Volume 1: 100GB (/mnt/data)                         │ │
│  │  ├─ PostgreSQL data directory                              │ │
│  │  ├─ Grafana dashboards                                     │ │
│  │  └─ Application data                                       │ │
│  │                                                              │ │
│  │  Block Volume 2: 100GB (/mnt/backups)                      │ │
│  │  ├─ LanceDB snapshots                                      │ │
│  │  ├─ Log archives                                           │ │
│  │  └─ Model backups                                          │ │
│  │                                                              │ │
│  │  Object Storage: 10GB (bucket: solo-brain-backups)         │ │
│  │  ├─ Off-site backup copies                                 │ │
│  │  └─ Archive exports                                        │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  DATABASE                                                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Autonomous DB 1: solo-users (20GB)                        │ │
│  │  ├─ user_accounts                                          │ │
│  │  ├─ api_keys                                              │ │
│  │  └─ usage_logs                                            │ │
│  │                                                              │ │
│  │  Autonomous DB 2: solo-metrics (20GB)                      │ │
│  │  ├─ hourly_metrics                                         │ │
│  │  ├─ performance_stats                                      │ │
│  │  └─ error_logs                                             │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  NETWORK                                                         │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  VCN: solo-vcn (10.0.0.0/16)                              │ │
│  │  ├─ Public Subnet: 10.0.1.0/24                            │ │
│  │  ├─ Private Subnet: 10.0.2.0/24                           │ │
│  │  ├─ Internet Gateway                                       │ │
│  │  ├─ NAT Gateway                                            │ │
│  │  └─ Security List (allow 80, 443, 22)                      │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Create Compute Instance

### 1.1 Create SSH Key

```bash
# Generate new SSH key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/oracle_solo_brain

# Copy public key
cat ~/.ssh/oracle_solo_brain.pub
```

### 1.2 Create Virtual Cloud Network (VCN)

```
1. Navigate to: Networking → Virtual Cloud Networks
2. Click "Create VCN"
3. Configure:
   - Name: solo-vcn
   - CIDR Block: 10.0.0.0/16
   - DNS Resolution: Enable
   - Hostname Resolution: Enable
4. Click "Create VCN"
```

### 1.3 Create Compute Instance

```
1. Navigate to: Compute → Instances
2. Click "Create Instance"
3. Configure:
   Name: solo-brain-dataplane

   Shape:
   - Select: Ampere A1
   - Shape: Standard.A1.Flex
   - OCPUs: 4 (Always Free limit)
   - Memory: 24 GB (Always Free limit)
   - Network Bandwidth: 1 Gbps

   Image:
   - Select: Oracle Linux
   - Version: 9 (or Ubuntu 22.04)

   SSH Key:
   - Paste: ~/.ssh/oracle_solo_brain.pub

   Networking:
   - VCN: solo-vcn
   - Subnet: Public Subnet
   - Assign Public IP: Yes

4. Click "Create"
```

### 1.4 Connect to Instance

```bash
# SSH into instance
ssh -i ~/.ssh/oracle_solo_brain opc@<public-ip>

# Or add to ~/.ssh/config
Host oracle-solo
    HostName <public-ip>
    User opc
    IdentityFile ~/.ssh/oracle_solo_brain

ssh oracle-solo
```

---

## Step 2: Attach Block Volume

### 2.1 Create Block Volume

```
1. Navigate to: Block Storage → Block Volumes
2. Click "Create Block Volume"
3. Configure:
   - Name: solo-data-volume
   - Size: 100 GB (Always Free limit is 200GB total)
   - Performance: Balanced
4. Click "Create Block Volume"
```

### 2.2 Attach to Instance

```
1. Select solo-data-volume
2. Click "Attach"
3. Select Instance: solo-brain-dataplane
4. Attachment Type: iSCSI
5. Click "Attach"
```

### 2.3 Mount on Instance

```bash
# SSH into instance
ssh oracle-solo

# List attached disks
sudo iscsiadm -m node -o show

# Find the new disk (usually /dev/sdb or /dev/oracleoci/oraclevdb)

# Create filesystem
sudo mkfs.ext4 /dev/sdb

# Create mount point
sudo mkdir -p /mnt/data

# Mount
sudo mount /dev/sdb /mnt/data

# Add to fstab for auto-mount on reboot
echo "/dev/sdb /mnt/data ext4 defaults 0 0" | sudo tee -a /etc/fstab

# Verify
df -h /mnt/data
```

---

## Step 3: Install PostgreSQL

```bash
# Update system
sudo dnf update -y

# Install PostgreSQL
sudo dnf install postgresql postgresql-server -y

# Initialize database
sudo /usr/bin/postgresql-setup --initdb --unit postgresql

# Start and enable
sudo systemctl enable --now postgresql

# Set password for postgres user
sudo -u postgres psql
\password postgres
\q

# Create database and user
sudo -u postgres createuser solo_user
sudo -u postgres createdb solo_brain -O solo_user

# Configure remote access (optional)
sudo vi /var/lib/pgsql/data/postgresql.conf
# Add: listen_addresses = '*'

sudo vi /var/lib/pgsql/data/pg_hba.conf
# Add: host all all 10.0.0.0/16 md5

sudo systemctl restart postgresql

# Open firewall port
sudo firewall-cmd --permanent --add-service=postgresql
sudo firewall-cmd --reload
```

---

## Step 4: Install Grafana & Prometheus

```bash
# Install Docker
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io -y
sudo systemctl enable --now docker

# Add user to docker group
sudo usermod -aG docker opc

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create docker-compose.yml
cat > /home/opc/monitoring/docker-compose.yml << 'EOF'
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_USERS_ALLOW_SIGN_UP=false

volumes:
  prometheus-data:
  grafana-data:
EOF

# Create Prometheus config
cat > /home/opc/monitoring/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'brain-api'
    static_configs:
      - targets: ['192.168.68.58:8080']
    metrics_path: '/metrics'
EOF

# Start monitoring
cd /home/opc/monitoring
docker-compose up -d

# Verify
docker-compose ps
```

---

## Step 5: Setup Object Storage

### 5.1 Create Bucket

```
1. Navigate to: Object Storage → Buckets
2. Click "Create Bucket"
3. Configure:
   - Name: solo-brain-backups
   - Compartment: root (or your compartment)
   - Storage Tier: Standard
4. Click "Create Bucket"
```

### 5.2 Upload via CLI

```bash
# Install OCI CLI
python3 -m pip install oci-cli

# Configure
oci setup config

# Test connection
oci os ns get

# Upload file
oci os object put -bn solo-brain-backups --name test.txt --file /path/to/file

# List objects
oci os object list -bn solo-brain-backups
```

---

## Step 6: Configure Autonomous Database

### 6.1 Create Autonomous Database

```
1. Navigate to: Oracle Database → Autonomous Databases
2. Click "Create Autonomous Database"
3. Configure:
   - Name: solo-users
   - Compartment: root
   - Workload type: Transaction Processing
   - Display name: SOLO Users Database
   - Always Free: Selected (20GB storage)
   - Compute: 1 OCPU (Always Free)
   - Storage: 20 GB (Always Free)
   - Admin password: [set strong password]
4. Click "Create Autonomous Database"
```

### 6.2 Connection Details

```
1. Click on solo-users database
2. DB Connection → Download Wallet
3. Extract and save to: /home/opc/wallet/

4. Connection string examples:
   - Connection string: (description=...)
   - Username: admin
   - Password: [your password]
```

---

## Step 7: Setup Backup Orchestrator

```bash
# Install backup script
cat > /home/opc/backup-brain.sh << 'EOF'
#!/bin/bash

# Backup Brain API data to Oracle Cloud
# Runs daily via cron

BRAIN_API_URL="http://192.168.68.58:8080"
BACKUP_DIR="/mnt/backups/lancedb"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
RETENTION_DAYS=30

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Trigger snapshot on Brain
echo "[$TIMESTAMP] Triggering Brain snapshot..."
SNAPSHOT_URL="$BRAIN_API_URL/admin/snapshot"
SNAPSHOT_FILE="lancedb-snapshot-$TIMESTAMP.lance"

# Download snapshot
echo "[$TIMESTAMP] Downloading snapshot..."
curl -s "$SNAPSHOT_URL" -o "$BACKUP_DIR/$SNAPSHOT_FILE"

# Upload to Object Storage
echo "[$TIMESTAMP] Uploading to Object Storage..."
oci os object put -bn solo-brain-backups \
    --name "lancedb/$SNAPSHOT_FILE" \
    --file "$BACKUP_DIR/$SNAPSHOT_FILE"

# Calculate checksum
CHECKSUM=$(sha256sum "$BACKUP_DIR/$SNAPSHOT_FILE" | awk '{print $1}')
echo "[$TIMESTAMP] Checksum: $CHECKSUM"

# Log to database (optional)
# psql -h localhost -U solo_user -d solo_brain \
#   -c "INSERT INTO backup_history VALUES ('$TIMESTAMP', '$SNAPSHOT_FILE', '$CHECKSUM', 'success');"

# Cleanup old backups
echo "[$TIMESTAMP] Cleaning up old backups (>$RETENTION_DAYS days)..."
find "$BACKUP_DIR" -name "*.lance" -mtime +$RETENTION_DAYS -delete

# Also cleanup from Object Storage (older than 90 days)
oci os object list -bn solo-brain-backups --prefix "lancedb/" | \
    jq -r '.data[] | select((now - ."time-created"|to_datetime) > 90*24*3600) | .name' | \
    xargs -I {} oci os object delete -bn solo-brain-backups --name "{}"

echo "[$TIMESTAMP] Backup complete!"
EOF

chmod +x /home/opc/backup-brain.sh

# Add to crontab (daily at 2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * /home/opc/backup-brain.sh >> /var/log/brain-backup.log 2>&1") | crontab -
```

---

## Security Configuration

### Firewall Rules

```bash
# Open required ports
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-port=3000/tcp  # Grafana
sudo firewall-cmd --permanent --add-port=5432/tcp  # PostgreSQL
sudo firewall-cmd --reload

# List rules
sudo firewall-cmd --list-all
```

### Security List in Console

```
1. VCN → solo-vcn → Security Lists → Default Security List
2. Add Ingress Rules:
   - Source: 0.0.0.0/0, IP Protocol: TCP, Dest Port: 22 (SSH)
   - Source: 0.0.0.0/0, IP Protocol: TCP, Dest Port: 80 (HTTP)
   - Source: 0.0.0.0/0, IP Protocol: TCP, Dest Port: 443 (HTTPS)
   - Source: Your IP, IP Protocol: TCP, Dest Port: 3000 (Grafana)
3. Add Egress Rules:
   - Destination: 0.0.0.0/0, IP Protocol: All
```

---

## Monitoring

### Check Always Free Usage

```
1. Dashboard → Always Free Resources
2. Review:
   - Compute usage (should be under limits)
   - Storage usage
   - Network egress
```

### Set Up Alerts

```
1. Monitoring → Alarms
2. Create Alarm for:
   - CPU > 80% for 5 minutes
   - Storage > 90% capacity
   - Instance down
```

---

## Limits Reference

| Resource | Always Free Limit |
|----------|------------------|
| **Compute** | 4 OCPU + 24GB RAM (Arm) OR 2 AMD VMs |
| **Block Storage** | 200GB total |
| **Object Storage** | 10GB each tier (Standard, IA, Archive) |
| **Autonomous DB** | 2 × 20GB |
| **Network Egress** | 10TB/month |
| **Load Balancers** | 1 Flexible + 3 Network |

---

## Troubleshooting

### Instance Won't Start

**Cause:** Exceeded Always Free compute limits

**Solution:**
- Stop unused instances
- Check: Compute → Instances → Always Free filter

### Can't Mount Block Volume

**Cause:** iSCSI initiator not configured

**Solution:**
```bash
sudo iscsiadm -m node -o new -T <iqn> -p <target_ip>
sudo iscsiadm -m node -l
```

### Connection Refused

**Cause:** Security list blocking port

**Solution:**
- Add ingress rule for specific port
- Check firewall: `sudo firewall-cmd --list-all`

---

*Document: 06_ORACLE_SETUP.md*
*Research Date: February 3, 2026*
