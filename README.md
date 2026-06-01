# Docker Restic Backup Stack

A modular, scalable Docker backup system using:

- Restic
- Database dumps using Supercronic-based scheduling
- docker compose stack

composed for my selfhosted services in my homelab

<!-- # Architecture
```text
Services
├── service1-postgres-backup
│   └── creates PostgreSQL dumps
│
├── service2-mongo-backup
│   └── creates MongoDB dumps
│
└── restic
    ├── backs up:
    │   ├── database dumps
    │   └── mounted service data
    │
    └── stores encrypted snapshots on NAS
```
 -->

<!-- # Why This Stack Exists
I wanted to backup my databases along with container data. But couldn't find an restic setup that didn't:
- one container does everything
- backup logic is tightly coupled
- adding new services is painfull

This stack separates responsibilities:

| Component          | Responsibility           |
|--------------------|--------------------------|
| db dump containers | create database dumps    |
| restic container   | stores encrypted backups | -->

# Supported Databases

Currently implemented:

- PostgreSQL
- MongoDB

Easy to add:

- MariaDB
- MySQL
- Redis
- SQLite
- ElasticSearch
- custom scripts



# How It Works

### File Structure

```text
docker_backup_stack/
├── compose.yml
├── deploy.env
│
├── staging/
│   ├── service/postgres/
│   └── service/mongo/
|
├── restore/
│
├── images/
│   ├── postgres-backup/
│   │   ├── Dockerfile
│   │   ├── backup.sh
│   │   └── entrypoint.sh
│   │
│   ├── mongo-backup/
│   │   ├── Dockerfile
│   │   ├── backup.sh
│   │   └── entrypoint.sh
│   │
│   └── restic/
│       ├── Dockerfile
│       ├── entrypoint.sh
│       └── run-restic.sh
│
└── README.md
```

## Step 1 — Database Dumps

Database-specific containers periodically create dumps.

Dumps are stored in:

```text
./staging/
```

Examples:
### PostgreSQL

```text
./staging/appflowy-postgres-2026-05-22-010000.sql.gz
```

### MongoDB

```text
./staging/overleaf-mongo-2026-05-22-013000.archive.gz
```




## Step 2 — Restic Backup

The Restic container backs up:

- database dumps
- linked service volumes in `./backupsources/`

to the NAS repository.

## Step 3 — Retention
Restic automatically prunes old snapshots.

Default retention:

| Type | Count |
|---|---|
| Daily | 7 |
| Weekly | 4 |
| Monthly | 6 |

defined in `run-restic.sh`

# Installation
## 1. Clone Repository

```bash
git clone https://github.com/Ryan-Diazz/docker_backup_stack.git

cd docker_backup_stack
```

## 2. Configure Environment

Copy and edit:

```bash
cp deploy.env .env
```

Edit:

```bash
nano .env
```

Set the enviroment variables:
- passwords
- hostnames
- cron schedules (if a different schedule is wanted)

### Cron Schedule Examples

| Schedule | Meaning |
|---|---|
| `0 1 * * *` | daily at 01:00 |
| `*/30 * * * *` | every 30 minutes |
| `0 */6 * * *` | every 6 hours |
| `0 0 * * 0` | every Sunday midnight |


## 3. Mount NAS Storage

### NFS (recommended)

Install NFS tools:

```bash
sudo apt install nfs-common
```

Create mount:

```bash
sudo mkdir -p /mnt/nas-backups
```

Mount NAS:

```bash
sudo mount -t nfs \
  192.168.2.250:/backups/restic \
  /mnt/nas-backups
```

Optional `/etc/fstab` entry:

```fstab
192.168.2.250:/backups/restic /mnt/nas-backups nfs defaults,_netdev 0 0
```


## 4. Build and Start

```bash
docker compose up -d --build
```


# Verify Backups

## Check logs

```bash
docker logs restic
```


## List snapshots

```bash
docker exec -it restic restic snapshots
```


# Restore Workflow

## Restore Latest Snapshot

```bash
docker exec -it restic \
  restic restore latest \
  --target /restore/latest
```

Restored files will appear in:

```text
./restore/
```


# Editing the Stack


## Adding a New Service

### 1. Add Service to compose.yml

Example:

```yaml
immich-backup:
  build: ./images/postgres-backup

  environment:
    CRON_SCHEDULE: ${IMMICH_POSTGRES_CRON}

  volumes:
    - ./staging/immich:/backup
```

### 2. Add Environment Variables
Example:

```env
# =============================================================================
# IMMICH
# =============================================================================

IMMICH_POSTGRES_HOST=immich-postgres
IMMICH_POSTGRES_DB=immich
IMMICH_POSTGRES_USER=immich
IMMICH_POSTGRES_PASSWORD=immich_DB_pass

IMMICH_POSTGRES_CRON=45 2 * * *
```

### 3. Mount Service Data for Restic

```bash
ln -s [SERVICE_DATA_PATH] ./backupsources/[SERVICE]
```

# Create Backup Image for database

Create:

```text
images/service-backup/
```

Add:
- Dockerfile
- backup.sh
- entrypoint.sh

look at the other images for inspiration

# Important Notes

## Restic Password

Changing the Restic password after initialization will make existing backups inaccessible unless migrated correctly.

Keep it safe.