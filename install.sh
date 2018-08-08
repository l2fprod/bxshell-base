#!/bin/bash
set -e

echo "Installing dependencies..."
apt-get -qq update && apt-get -qq install -y \
  apt-transport-https \
  bash-completion \
  ca-certificates \
  curl \
  figlet \
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
  nano \
  python \
  python-virtualenv \
  python-setuptools \
  python-pip \
  silversearcher-ag \
  software-properties-common \
  sudo \
  tmux \
  unzip \
  vim \
  wget \
  zip

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
curl -LO "https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')_linux_amd64.zip" && \
  unzip terraform*.zip && \
  rm -f terraform*.zip && \
  chmod 755 terraform && \
  mv terraform /usr/local/bin

# Yarn
echo "Yarn"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get -qq update && apt-get install -qq -y yarn

# Colors for nano
echo "Colors for nano"
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

# Cleanup
echo "Cleanup"
apt-get clean && rm -rf /var/lib/apt/lists/*
