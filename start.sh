#!/bin/bash

# This script is used to set up a GitHub Actions runner on a Proxmox VM.
set -e
set -euo pipefail
set -x

# Define the architecture and runner version
ARCH=x64
RUNNER_VERSION=2.326.0
REPO=$GITHUB_REPOSITORY
ACCESS_TOKEN=$GH_ACCESS_TOKEN

# you can change the username to whatever you like, but make sure to update the user in the entrypoint script
sudo apt-get update -y && sudo apt-get upgrade -y && sudo useradd -m gitrunner && sudo usermod -aG sudo gitrunner

# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
sudo apt-get update -y

sudo apt-get install -y curl jq build-essential openssh-client

#sudo apt-get install -y --no-install-recommends libicu-dev libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip --fix-missing   

# cd into the user directory, download and unzip the github actions runner
cd /home/gitrunner && mkdir actions-runner && cd actions-runner && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz \
&& tar xzf ./actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz



echo "REPO ${REPO}"
echo "ACCESS_TOKEN ${ACCESS_TOKEN}"


REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/repos/${REPO}/actions/runners/registration-token | jq .token --raw-output)


echo "REG_TOKEN ${REG_TOKEN}"

cd /home/gitrunner/actions-runner

./config.sh --url https://github.com/${REPO} --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!