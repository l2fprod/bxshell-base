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
  python-argcomplete \
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
echo ">> Locale"
locale-gen en_US.UTF-8

# Docker in Docker
echo ">> Docker in Docker"
apt-get -qq remove docker docker-engine docker.io
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get -qq update && apt-get -qq -y install docker-ce

# Terraform
#latest_terraform_version=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
latest_terraform_version="0.12.29"
echo ">> Terraform ($latest_terraform_version -- marking as latest)"

curl -LO "https://releases.hashicorp.com/terraform/${latest_terraform_version}/terraform_${latest_terraform_version}_linux_amd64.zip"
unzip terraform_${latest_terraform_version}_linux_amd64.zip terraform
mv terraform /usr/local/bin/terraform-${latest_terraform_version}
rm -f terraform_${latest_terraform_version}_linux_amd64.zip
ln -s /usr/local/bin/terraform-${latest_terraform_version} /usr/local/bin/terraform-latest
ln -s /usr/local/bin/terraform-${latest_terraform_version} /usr/local/bin/terraform

echo ">> Terraform (0.11.14)"
curl -LO "https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip"
unzip terraform_0.11.14_linux_amd64.zip terraform
mv terraform /usr/local/bin/terraform-0.11.14
rm -f terraform_0.11.14_linux_amd64.zip

echo ">> TFSwitch"
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

echo ">> terraform-docs"
curl -LO $(get_most_recent_matching "terraform-docs/terraform-docs" ".*-linux-amd64$")
mv terraform-docs-*-linux-amd64 terraform-docs
chmod +x terraform-docs
mv terraform-docs /usr/local/bin/

echo ">> Blast Radius"
pip3 install blastradius

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
activate-global-python-argcomplete

# Cleanup
echo ">> Cleanup"
apt-get clean && rm -rf /var/lib/apt/lists/*
