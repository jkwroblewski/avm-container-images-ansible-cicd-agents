#!/bin/bash
set -e

# Validate required environment variables
if [ -z "$AZP_URL" ]; then
  echo "Error: AZP_URL is not set"
  exit 1
fi

if [ -z "$AZP_TOKEN" ]; then
  echo "Error: AZP_TOKEN is not set"
  exit 1
fi

if [ -z "$AZP_POOL" ]; then
  export AZP_POOL="Default"
fi

if [ -z "$AZP_AGENT_NAME" ]; then
  export AZP_AGENT_NAME="ansible-agent-$(hostname)"
fi

echo "================================================"
echo "Azure DevOps Agent Configuration"
echo "================================================"
echo "Agent Name: $AZP_AGENT_NAME"
echo "Agent Pool: $AZP_POOL"
echo "Organization URL: $AZP_URL"
echo "Agent Version: ${AGENT_VERSION:-built-in}"
echo "================================================"

# Verify agent binaries are present
if [ ! -f ./config.sh ]; then
  echo "ERROR: Agent binaries not found!"
  echo "The agent should have been downloaded during image build."
  exit 1
fi

echo "Agent binaries verified successfully"

# Configure the agent
echo "Configuring agent: $AZP_AGENT_NAME"
./config.sh \
  --unattended \
  --url "$AZP_URL" \
  --auth pat \
  --token "$AZP_TOKEN" \
  --pool "$AZP_POOL" \
  --agent "$AZP_AGENT_NAME" \
  --replace \
  --acceptTeeEula

# Cleanup token from environment for security
unset AZP_TOKEN

echo "Agent configured successfully!"
echo "Starting agent..."
echo "================================================"

# Run the agent (supports --once flag for one-shot execution)
./run.sh "$@"
