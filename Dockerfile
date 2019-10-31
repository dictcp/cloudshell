# ubuntu 18.04 base image
FROM ubuntu:18.04

# ref: dictcp/utils
RUN apt-get update && \
    apt-get -y install python3.6-minimal python3-distutils gawk sed jq tar unzip git curl wget redir socat traceroute haproxy rsync && \
    curl -o get-pip.py https://bootstrap.pypa.io/get-pip.py && python3.6 get-pip.py && rm get-pip.py && \
    pip --no-cache-dir install awscli httpie yq

# Kubernetes tools
ENV KUBECTL_VERSION 1.16.2
RUN curl -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Docker bin
COPY --from=docker:19.03 /usr/local/bin/docker /usr/local/bin/
RUN groupadd -g 999 docker

# PHP 7.2
RUN env DEBIAN_FRONTEND=noninteractive apt-get -y install php7.2

# NodeJS 10 and yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# Go 1.12
ENV GOLANG_VERSION 1.12.4
RUN wget -q https://dl.google.com/go/go$GOLANG_VERSION.linux-amd64.tar.gz && \
    tar zxf go$GOLANG_VERSION.linux-amd64.tar.gz && \
    mv go /usr/local/lib/go && \
    ln -s /usr/local/lib/go/bin/go /usr/local/bin/go && \
    ln -s /usr/local/lib/go/bin/godoc /usr/local/bin/godoc && \
    ln -s /usr/local/lib/go/bin/gofmt /usr/local/bin/gofmt && \
    rm go$GOLANG_VERSION.linux-amd64.tar.gz

# Dart
RUN wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list && \
    apt-get update && apt-get install -y dart && \
    echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> /etc/profile.d/04-dart-bin.sh

# Misc tools (from code-server & sys-init)
RUN apt-get -y install dumb-init sudo locales net-tools openssl && \
    apt-get -y install byobu vim \
                       silversearcher-ag pv \
                       net-tools mosh
