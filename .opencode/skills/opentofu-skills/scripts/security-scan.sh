#!/usr/bin/env bash
# scripts/security-scan.sh

# Run security scans using Docker containers
# Usage: ./scripts/security-scan.sh [--strict]

STRICT_MODE=false
[ "$1" == "--strict" ] && STRICT_MODE=true

# TRIVY_VERSION="0.50.0"
CHECKOV_VERSION="3.2.30"

# echo "=== Pulling images ==="
# docker pull "aquasec/trivy:${TRIVY_VERSION}"
docker pull "bridgecrew/checkov:${CHECKOV_VERSION}"

# echo "=== Running Trivy IaC Scan ==="
# docker run --rm -v $(pwd):/workspace aquasec/trivy:${TRIVY_VERSION} config --severity HIGH,CRITICAL /workspace --misconfig-scanners terraform
# TRIVY_EXIT=$?

echo "=== Running Checkov Scan ==="
docker run --rm -v $(pwd):/workspace bridgecrew/checkov:${CHECKOV_VERSION} -d /workspace --compact --skip-path "/.terraform"
CHECKOV_EXIT=$?

if [ "$STRICT_MODE" == "true" ]; then
  [ $CHECKOV_EXIT -ne 0 ] && exit 1
fi