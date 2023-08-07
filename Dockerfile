FROM codercom/code-server:latest as cs

FROM ubuntu:22.04

ENV GO_VERSION=1.20.3

# install code-server
COPY --from=cs /usr/bin/code-server /usr/bin/code-server
COPY --from=cs /usr/lib/code-server /usr/lib/code-server
RUN ln -s /usr/local/lib/code-server/code-server /usr/local/bin/code-server

# Install Rust, Python, Vim, Git
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    tini \
    gpg \
    apt-transport-https \
    openssh-client \
    apt-transport-https \ 
    ca-certificates \
    cargo \
    curl \
    git \
    vim \
    build-essential \
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
# COPY ./script/code-server-extension.sh ./script/code-server-extension.sh
# RUN . ./script/code-server-extension.sh

ENTRYPOINT ["tini","--","/script/init.sh"]