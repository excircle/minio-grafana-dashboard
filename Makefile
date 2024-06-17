# Default target
all: setup grafana prometheus

# Check and create data directories if they don't exist
setup:
	@echo "Checking and creating directories..."
	@[ ! -d "minio-data1" ] && mkdir minio-data1 || true
	@[ ! -d "minio-data2" ] && mkdir minio-data2 || true

# Grafana setup and directory extraction
grafana:
	@echo "Setting up Grafana..."
	docker run --name temp-grafana -d grafana/grafana
	docker cp temp-grafana:/var/lib/grafana ./grafana
	docker stop temp-grafana
	docker rm temp-grafana

# Prometheus setup and directory extraction
prometheus:
	@echo "Setting up Prometheus..."
	docker run --name temp-prometheus -d prom/prometheus
	docker cp temp-prometheus:/prometheus ./prom-data
	docker cp temp-prometheus:/etc/prometheus ./
	docker stop temp-prometheus
	docker rm temp-prometheus

.PHONY: all setup grafana prometheus
