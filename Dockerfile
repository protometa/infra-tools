FROM ubuntu:16.04

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    bash-completion \
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
RUN curl -fsSL https://get.docker.com | sh

# install docker-compose and awscli
RUN pip --no-cache-dir install docker-compose awscli s3cmd pipenv \
  && curl -L https://raw.githubusercontent.com/docker/compose/1.22.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose \
  && echo "complete -C '/usr/local/bin/aws_completer' aws" >> ~/.bashrc

# install kops
ARG KOPS_VERSION=1.9.2
RUN curl -L https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 \
  > /usr/local/bin/kops && chmod +x /usr/local/bin/kops \
  && kops completion bash >> ~/.bashrc

# install kubectl
ARG KUBECTL_VERSION=1.11.1
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  > /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl \
  && kubectl completion bash >> ~/.bashrc

# install helm
ARG HELM_VERSION=2.9.1
RUN curl -L https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
  | tar -zx -C /usr/local/bin --strip-components=1 linux-amd64/helm \
  && helm completion bash >> ~/.bashrc

# install Pulumi
RUN curl -fsSL https://get.pulumi.com | sh
ENV PATH=$PATH:/root/.pulumi/bin

# install Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash \
  && apt-get install -yq nodejs build-essential \
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
RUN curl -sL https://dist.ipfs.io/go-ipfs/v0.4.17/go-ipfs_v0.4.17_linux-amd64.tar.gz \
  | tar -zx -C /usr/local/bin --strip-components=1 go-ipfs/ipfs

# install OpenSSH v7.5
RUN wget https://launchpadlibrarian.net/335526589/openssh-client_7.5p1-10_amd64.deb \
  && wget https://launchpadlibrarian.net/298453050/libgssapi-krb5-2_1.14.3+dfsg-2ubuntu1_amd64.deb \
  && wget https://launchpadlibrarian.net/298453058/libkrb5-3_1.14.3+dfsg-2ubuntu1_amd64.deb \
  && wget https://launchpadlibrarian.net/298453060/libkrb5support0_1.14.3+dfsg-2ubuntu1_amd64.deb \
  && dpkg -i libkrb5support0_1.14.3+dfsg-2ubuntu1_amd64.deb \
  && dpkg -i libkrb5-3_1.14.3+dfsg-2ubuntu1_amd64.deb \
  && dpkg -i libgssapi-krb5-2_1.14.3+dfsg-2ubuntu1_amd64.deb \
  && dpkg -i openssh-client_7.5p1-10_amd64.deb \
  && rm libkrb5support0_1.14.3+dfsg-2ubuntu1_amd64.deb \
    libkrb5-3_1.14.3+dfsg-2ubuntu1_amd64.deb \
    libgssapi-krb5-2_1.14.3+dfsg-2ubuntu1_amd64.deb \
    openssh-client_7.5p1-10_amd64.deb

# use bash-completion
RUN echo '[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion' >> ~/.bashrc

CMD ["bash", "-l"]
