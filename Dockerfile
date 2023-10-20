FROM codercom/code-server:latest as cs

FROM ubuntu:22.04

ARG USERNAME=beyond
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV GO_VERSION=1.20.3
ENV DEBIAN_FRONTEND noninteractive
ENV S6_OVERLAY_VERSION="3.1.5.0"
ENV PIP_ROOT_USER_ACTION=ignore

# install code-server
COPY --from=cs /usr/bin/code-server /usr/bin/code-server
COPY --from=cs /usr/lib/code-server /usr/lib/code-server
RUN ln -s /usr/local/lib/code-server/code-server /usr/local/bin/code-server

# Install Rust, Python, Vim, Git
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    tini \
    gpg \
    openssh-client \
    apt-transport-https \ 
    ca-certificates \
    cargo \
    curl \
    git \
    vim \
    build-essential \
    python-is-python3 \
    python3 \
    python3-pip \
    python3-venv \
    nginx

# Install NodeJS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - 
RUN sudo apt-get install -y nodejs

# Install Jupyter Lab
RUN pip install jupyterlab

# Copy init.sh
COPY ./script/init.sh /script/init.sh
RUN chmod +x /script/init.sh

# Copy reverse_proxy.conf
COPY ./reverse_proxy.conf /etc/nginx/sites-available/default

# Install golang
COPY ./script/golang.sh ./script/golang.sh
RUN . ./script/golang.sh

# Install Code Server Extension
COPY ./script/code-server-extension.sh ./script/code-server-extension.sh
RUN . ./script/code-server-extension.sh

COPY ./html  /usr/share/nginx/html

ENV USER_NAME=beyond
ENV GROUP_NAME=nogroup
ENV HOME_DIR=/home/$USER_NAME

RUN groupadd -g 65534 $GROUP_NAME && useradd -rm -d $HOME_DIR -s /bin/bash -g $GROUP_NAME -G sudo -u 65534 $USER_NAME
RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY ./script/copy-vs-code-extension.sh ./script/copy-vs-code-extension.sh
RUN . ./script/copy-vs-code-extension.sh

ENTRYPOINT ["tini","--","/script/init.sh"]

USER $USER_NAME
WORKDIR $HOME_DIR