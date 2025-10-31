FROM mcr.microsoft.com/azure-powershell:ubuntu-22.04
ENV TARGETARCH="linux-x64"

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libicu70 \
        libcurl4 \
        libunwind8 \
        netcat \
        ruby \
        unzip \
        dnsutils \
        openssh-client \
        python3 \
        python3-pip \
        libicu-dev \
        sshpass \
        && apt-get clean && rm -rf /var/lib/apt/lists/* 

#install Ansible form pip
RUN pip3 install --quiet --no-cache-dir \
    ansible \
    ansible-core \
    azure-cli \
    azure-keyvault-secrets \
    azure-identity \
    pywinrm \
    --break-system-packages

# Install Ansible collections
RUN ansible-galaxy collection install azure.azcollection


RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./start.sh" ]
