FROM ubuntu:16.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    python \
    python-pip \
    python-setuptools \
    git \
    jq \
    ssh \
  && apt-get clean \
  && apt-get autoclean \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install Docker
ENV DOCKER_HOST=tcp://docker:2375
RUN curl -fsSL https://get.docker.com | sh

# install awscli
RUN pip --no-cache-dir install awscli s3cmd pipenv

# install kops
ARG KOPS_VERSION=1.9.1
RUN curl -L https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 \
  > /usr/local/bin/kops && chmod +x /usr/local/bin/kops

# install kubectl
ARG KUBECTL_VERSION=1.10.2
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  > /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

# install helm
ARG HELM_VERSION=2.8.2
RUN curl -L https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
  | tar -zx linux-amd64/helm \
  && mv linux-amd64/helm /usr/local/bin/helm

# install Pulumi
RUN curl -fsSL https://get.pulumi.com | sh
ENV PATH=$PATH:/root/.pulumi/bin

# install Node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash \
  && apt-get install -yq nodejs build-essential \
  && npm i -g npm
