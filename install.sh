#!/bin/bash
set -e

function get_most_recent_matching {
  releases=$(curl -H "Authorization: token $GITHUB_TOKEN" --silent "https://api.github.com/repos/$1/releases")
  most_recent_matching=$(echo -E $releases | jq -r '.[] | .assets | .[] | select(.browser_download_url | test("'$2'")) | .browser_download_url' | head -n 1)
  if [ ! -z "$most_recent_matching" ]; then
    echo $most_recent_matching
  else
    echo "Failed to get $1: $releases"
    exit 2
  fi
}

echo ">> Installing dependencies..."
apt -qq update && apt -qq install -y \
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
  python3-argcomplete \
  python3-pip \
  python3-setuptools \
  python3-virtualenv \
  silversearcher-ag \
  software-properties-common \
  sudo \
  tmux \
  unzip \
  vim \
  wget \
  zip

# Locale
echo ">> Locale"
locale-gen en_US.UTF-8

# Docker in Docker
echo ">> Docker in Docker"
apt remove docker docker-engine docker.io containerd runc || true
apt -qq -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt -qq update
apt -qq -y install docker-ce docker-ce-cli containerd.io


echo ">> TFSwitch"
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

echo ">> terraform-docs"
curl -LO $(get_most_recent_matching "terraform-docs/terraform-docs" ".*-linux-amd64$")
mv terraform-docs-*-linux-amd64 terraform-docs
chmod +x terraform-docs
mv terraform-docs /usr/local/bin/

echo ">> Blast Radius"
pip install blastradius

# Ansible
echo ">> Ansible"
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -qq -y ansible

# Yarn
echo ">> Yarn"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get -qq update && apt-get install -qq -y yarn

# MC for S3
echo ">> minio"
wget -O /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x /usr/local/bin/mc

# Colors for nano
echo ">> Colors for nano"
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

# Powerline
echo ">> Powerline"
pip install powerline-shell

# yq - jq for yaml
echo ">> yq"
pip install yq

# argcomplete
activate-global-python-argcomplete3

# Cleanup
echo ">> Cleanup"
apt-get clean && rm -rf /var/lib/apt/lists/*
