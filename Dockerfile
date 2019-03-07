FROM gcr.io/cloudshell-images/cloudshell:latest

RUN apt-get update && apt-get -y install \
        vim git-core wget curl zsh \
        redir socat axel \
        mosh jq pv httpie \
        silversearcher-ag
