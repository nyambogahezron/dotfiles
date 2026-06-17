#!/bin/bash

# Observability Stack Setup (Docker Compose based)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

install_observability() {
    print_header "SETTING UP OBSERVABILITY STACK"

    local OBS_DIR="$DOTFILES_DIR/observability"
    mkdir -p "$OBS_DIR"

    print_step "Scaffolding docker-compose.yml for Observability tools..."

    cat << 'EOF' > "$OBS_DIR/docker-compose.yml"
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - prometheus
      - loki
      - tempo
    restart: unless-stopped

  loki:
    image: grafana/loki:latest
    container_name: loki
    ports:
      - "3100:3100"
    restart: unless-stopped

  tempo:
    image: grafana/tempo:latest
    container_name: tempo
    command: [ "-config.file=/etc/tempo.yaml" ]
    volumes:
      - ./tempo.yaml:/etc/tempo.yaml
    ports:
      - "3200:3200"
      - "4317:4317"  # otlp grpc
    restart: unless-stopped

  victoriametrics:
    image: victoriametrics/victoria-metrics:latest
    container_name: victoriametrics
    ports:
      - "8428:8428"
    command:
      - "-retentionPeriod=1"
    restart: unless-stopped

  redis:
    image: redis:latest
    container_name: redis
    ports:
      - "6379:6379"
    restart: unless-stopped
EOF

    # Create base configs to prevent startup crashes
    if [ ! -f "$OBS_DIR/prometheus.yml" ]; then
        cat << 'EOF' > "$OBS_DIR/prometheus.yml"
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF
    fi

    if [ ! -f "$OBS_DIR/tempo.yaml" ]; then
        cat << 'EOF' > "$OBS_DIR/tempo.yaml"
server:
  http_listen_port: 3200
distributor:
  receivers:
    otlp:
      protocols:
        grpc:
EOF
    fi

    print_success "Observability stack created at $OBS_DIR"
    echo -e "${YELLOW}Note: The stack is not started automatically.${NC}"
    echo -e "${CYAN}To start it, run: cd $OBS_DIR && docker compose up -d${NC}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_observability
fi
