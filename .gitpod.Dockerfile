FROM gitpod/workspace-base:latest

# Openstack cli / MySQL cli
RUN sudo apt update && sudo apt -y install \
    gettext \
    jq \
    python3-aodhclient \
    python3-barbicanclient \
    python3-ceilometerclient \
    python3-cinderclient \
    python3-cloudkittyclient \
    python3-designateclient \
    python3-gnocchiclient \
    python3-octaviaclient \
    python3-osc-placement \
    python3-openstackclient \
    python3-pankoclient \
    python3-pip \
    python3-venv \
    zip \
    gnupg \
    software-properties-common \
    curl

# Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
RUN sudo apt-get update && sudo apt-get install terraform

# Ansible
RUN sudo add-apt-repository -y ppa:ansible/ansible
RUN sudo apt update && sudo apt install -y ansible

# Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
        && sudo mv ./kubectl /usr/local/bin/kubectl \
        && sudo chmod 0755 /usr/local/bin/kubectl

# Pre-commit
RUN pip install pre-commit

# Tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
