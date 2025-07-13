#!/usr/bin/env bash
set -euo pipefail

if [ -z "${RUNNER_CFG_PAT:-}" ]; then
  echo "Error: RUNNER_CFG_PAT env var not set. Export it before running."
  exit 1
fi

# Usage: install-github-runner.sh owner/repo-or-org [runner_name] [labels]
REPO_OR_ORG=${1:-}
RUNNER_NAME=${2:-}
LABELS=${3:-}

if [ -z "$REPO_OR_ORG" ]; then
  echo "Usage: $0 <owner/repo-or-org> [runner_name] [labels]"
  exit 1
fi

echo "Installing self-hosted runner for: $REPO_OR_ORG"

# Download & run the official script
curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/create-latest-svc.sh \
  | bash -s -- -s "$REPO_OR_ORG" ${RUNNER_NAME:+-n "$RUNNER_NAME"} ${LABELS:+-l "$LABELS"}

echo "✅ Runner installation initiated. Use systemctl to check status:"
echo "   sudo systemctl status actions.runner.$(hostname).service"
