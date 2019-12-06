#!/bin/bash
set -e

echo "Installing dependencies..."
apt-get -qq update && apt-get -qq install -y \
  apt-transport-https \
  apache2-utils \
  bash-completion \
  ca-certificates \
  curl \
  figlet \
  gettext \
  graphviz \
  inetutils-ping \
  jq \
  libasound2 \
  libgconf2-dev \
  libgtkextra-dev \
  libnss3 \
  libx11-xcb1 \
  libxss1 \
  libxtst-dev \
  locales \
  nano \
  python \
  python-virtualenv \
  python-setuptools \
  python-pip \
  python3-pip \
  silversearcher-ag \
  software-properties-common \
  sudo \
  tmux \
  unzip \
  vim \
  wget \
  zip

# Locale
echo "Locale"
locale-gen en_US.UTF-8

# Docker in Docker
echo "Docker in Docker"
apt-get -qq remove docker docker-engine docker.io
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get -qq update && apt-get -qq -y install docker-ce

# Terraform
echo "Terraform"
# curl -LO "https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')_linux_amd64.zip" && \
curl -LO "https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip" && \
  unzip terraform*.zip && \
  rm -f terraform*.zip && \
  chmod 755 terraform && \
  mv terraform /usr/local/bin

# Ansible
echo "Ansible"
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -qq -y ansible

# Yarn
echo "Yarn"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get -qq update && apt-get install -qq -y yarn

# Colors for nano
echo "Colors for nano"
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

# Powerline
echo "Powerline"
pip install powerline-shell

# yq - jq for yaml
pip install yq

# Cleanup
echo "Cleanup"
apt-get clean && rm -rf /var/lib/apt/lists/*
