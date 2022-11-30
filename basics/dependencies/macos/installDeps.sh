#!/bin/bash

# requitements through brew
brew install curl gettext gnupg jq zip

# required python libraries
pip install aodhclient python-barbicanclient python-ceilometerclient python-cinderclient python-cloudkittyclient \
 python-designateclient gnocchiclient python-octaviaclient osc-placement python-openstackclient pankoclient \

# Terraform
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Ansible
pip install ansible --user
# it sounds better to first create a venv theninstall ansible. up to your choice.
# python3 -m venv <path to your desired venv>
# source <path to your desired venv>/bin/activate
# pip install ansible

# kubectl
sudo mv ./kubectl /usr/local/bin/kubectl \
        && sudo chmod 0755 /usr/local/bin/kubectl

# kubectl for Apple Silicon models
brew install kubernetes-cli
