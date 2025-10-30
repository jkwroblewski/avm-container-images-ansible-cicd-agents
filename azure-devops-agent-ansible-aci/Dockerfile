FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    openssh-client \
    python3 \
    python3-pip \
    libicu-dev \
    sshpass \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Ansible via pip (more reliable than PPA)
RUN pip3 install --no-cache-dir \
    ansible \
    ansible-core \
    azure-cli \
    azure-keyvault-secrets \
    azure-identity \
    pywinrm \
    --break-system-packages

# Install Ansible collections
RUN ansible-galaxy collection install azure.azcollection

# Azure DevOps agent version
ARG AGENT_VERSION=3.245.0

# Create non-root user for agent
RUN useradd -m -s /bin/bash azp \
    && mkdir -p /azp \
    && chown -R azp:azp /azp

WORKDIR /azp

# Download and extract Azure Pipelines agent
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && chown -R azp:azp /azp

# Copy startup script
COPY start.sh /azp/start.sh
RUN chmod +x /azp/start.sh && chown azp:azp /azp/start.sh

# Switch to non-root user
USER azp

# Store agent version as environment variable for reference
ENV AGENT_VERSION=${AGENT_VERSION}

ENTRYPOINT ["/azp/start.sh"]
