# MinIO Grafana Dashboard

This repository is dedicated to visulizing multiple MinIO clusters into a single Grafana dashboard.

This configuration captures the following primary metrics:

- Capacity/Usage
- Throughput
- Requests-Per-Second
- Average/Mean Time-To-First-Byte

# Instructions for Deploying

This project was built and deployed using a Macbook Pro (M3). While it can be utilized on a non-MacOS environment such as Linux, the instructions are specifically written for Mac. Please adjust your procedure to fit your target environment.

#### Prerequisites

This project depends on the presence of [Docker Desktop](https://docs.docker.com/desktop/install/mac-install/).

#### 1.) Run Makefile to Stage Requisite Directories

```bash
# Target 'all' directive for Makefile
make all
```

#### 2.) Run Docker Compose 'up' to Launch Project

Use the `docker` installation to run Docker Compose project. Instructions feature the `-d` for detached mode.

```bash
docker compose up -d
```

#### 3.) Access MinIO Instances to Generate Prometheus Configuration

```bash
# Access MinIO Host
user@host~: docker exec -it minio1 /bin/bash

# Set MinIO Alias
bash-5.1# mc alias set minio1 http://minio1:9000 minioadmin minioadmin

mc: Configuration written to `/tmp/.mc/config.json`. Please update your access credentials.
mc: Successfully created `/tmp/.mc/share`.
mc: Initialized share uploads `/tmp/.mc/share/uploads.json` file.
mc: Initialized share downloads `/tmp/.mc/share/downloads.json` file.
Added `minio1` successfully.

# Generate Prometheus Job
bash-5.1# mc admin prometheus generate minio1
scrape_configs:
- job_name: minio-job
  bearer_token: $TOKEN_VALUE
  metrics_path: /minio/v2/metrics/cluster
  scheme: http
  static_configs:
  - targets: ['minio1:9000']
```

#### 4.) Add to Prometheus config file in ${PROJECT_ROOT}/prometheus/promethus.yml

```yaml
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9090"]
  - job_name: minio1
    scrape_interval: 15s
    scrape_timeout: 10s
    bearer_token: $TOKEN_VALUE
    metrics_path: /minio/v2/metrics/cluster
    scheme: http
    static_configs:
    - targets: ['minio1:9000']
```

#### 5.) Add MinIO Dashboard to Grafana Instance

Add the MinIO Dashboard as a starting point for Dashboard. The MinIO Dashboard ID is `13502`

![Dashboard](https://learn.microsoft.com/en-us/azure/managed-grafana/media/create-dashboard/import-load.png)