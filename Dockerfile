FROM ubuntu:16.04
RUN apt-get -qq update && apt-get -qq install -y \
  apt-transport-https \
  bash-completion \
  ca-certificates \
  curl \
  figlet \
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
  software-properties-common \
  sudo \
  unzip \
  wget \
  zip

# Docker in Docker
RUN apt-get -qq remove docker docker-engine docker.io
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get -qq update && apt-get -qq -y install docker-ce

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get -qq update && apt-get install -qq -y yarn

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
