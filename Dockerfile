FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    bash-completion \
    python3 \
    python3-pip \
    python3-dev \
    python3-setuptools \
    git \
    jq \
    ssh \
    locales \
  && apt-get clean \
  && apt-get autoclean \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setup locales
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# install Docker
RUN curl -fsSL https://get.docker.com | sh

# install docker-compose and awscli
RUN pip3 --no-cache-dir install docker-compose awscli s3cmd pipenv \
  && curl -L https://raw.githubusercontent.com/docker/compose/1.22.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose \
  && echo "complete -C '/usr/local/bin/aws_completer' aws" >> ~/.bashrc

# install kops
ARG KOPS_VERSION=1.9.2
RUN curl -L https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 \
  > /usr/local/bin/kops && chmod +x /usr/local/bin/kops \
  && kops completion bash >> ~/.bashrc

# install kubectl
ARG KUBECTL_VERSION=1.13.1
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  > /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl \
  && kubectl completion bash >> ~/.bashrc

# install helm
ARG HELM_VERSION=3.3.4
RUN curl -L https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz \
  | tar -zx -C /usr/local/bin --strip-components=1 linux-amd64/helm \
  && helm completion bash >> ~/.bashrc

# install Pulumi
ARG PULUMI_VERSION=2.12.0
RUN curl -fsSL https://get.pulumi.com | sh -s -- --version $PULUMI_VERSION
ENV PATH=$PATH:/root/.pulumi/bin

# install Node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash \
  && apt-get install -yq nodejs \
  && npm i -g npm \
  && npm completion >> ~/.bashrc

# install aws-iam-authenticator
RUN curl -L https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator \
  > /usr/local/bin/aws-iam-authenticator && chmod +x /usr/local/bin/aws-iam-authenticator

# install kubetail
RUN curl -L https://github.com/johanhaleby/kubetail/archive/1.6.1.tar.gz \
  | tar -zx -C /usr/local/bin --strip-components=1 kubetail-1.6.1/kubetail \
  && curl -L https://github.com/johanhaleby/kubetail/archive/1.6.1.tar.gz \
  | tar -zx kubetail-1.6.1/completion/kubetail.bash -O >> ~/.bashrc

# install ipfs
ARG IPFS_VERSION=0.4.18
RUN curl -sL https://dist.ipfs.io/go-ipfs/v${IPFS_VERSION}/go-ipfs_v${IPFS_VERSION}_linux-amd64.tar.gz \
  | tar -zx -C /usr/local/bin --strip-components=1 go-ipfs/ipfs

# use bash-completion
RUN echo '[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion' >> ~/.bashrc

CMD ["bash", "-l"]
