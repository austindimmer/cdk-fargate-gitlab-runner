# https://github.com/microsoft/vscode-dev-containers/tree/main/containers/python-3-anaconda

# FROM continuumio/anaconda3
# FROM debian:buster-slim
FROM ubuntu:20.04

USER root

# Copy library scripts to execute
# Good source for library install scripts
# https://github.com/microsoft/vscode-dev-containers
# https://github.com/microsoft/vscode-dev-containers/tree/main/script-library
WORKDIR /tmp/library-scripts
COPY /library-scripts/*.sh /tmp/library-scripts/

# convert line endings just in case
RUN ls
# RUN sed -i -e 's/\r\+$//' **/*.sh
WORKDIR /
# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"

# [Option] Use the OSS Moby Engine instead of the licensed Docker Engine
ARG USE_MOBY="true"

ARG TINI_VERSION=v0.19.0


# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
# ARG USERNAME=node
# ARG USER_UID=1000
# ARG USER_GID=$USER_UID
# ENV env_user_name=$USERNAME

USER root

# 2>&1 is used to redirect stderr to std out which is useful to suppresss warnings we are not too woried about in VSCode terminal during docker build

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    # && bash /tmp/library-scripts/powershell-debian-alt.sh 2>&1 \
    # Use Docker script from script library to set things up
    && bash /tmp/library-scripts/github-debian.sh \
    && bash /tmp/library-scripts/terraform-debian.sh 2>&1 \
    # && bash /tmp/library-scripts/aws-cli.sh 2>&1 \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*


# RUN useradd -ms /bin/bash $env_user_name
# USER $env_user_name
# WORKDIR /home/$env_user_name

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
# ARG NODE_VERSION="lts/*"
# ENV NVM_DIR=/usr/local/share/nvm
# ENV NVM_SYMLINK_CURRENT=true \
#     PATH=${NVM_DIR}/current/bin:${PATH}
# RUN bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}" \
#     && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ENV NODE_VERSION=16.13.0
RUN apt-get install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

RUN apt-get update
RUN apt-get install -y python3-pip

RUN pip3 install aws-sam-cli 2>&1
RUN pip3 install pipenv 2>&1
# Install global node modules
RUN npm install -g npm@8.5.0
RUN npm install -g pnpm@6.31.0 2>&1
RUN npm install -g aws-cdk@1.127.0 cdk-assume-role-credential-plugin@1.4.0 2>&1
RUN npm install -g snyk 2>&1
RUN npm install -g npm-upgrade 2>&1
RUN npm install -g @mhlabs/cfn-diagram 2>&1
RUN npm install -g cdk-dia 2>&1


# Remove library scripts for final image
RUN rm -rf /tmp/library-scripts


RUN apt-get autoclean -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends tree mc graphviz


# ---------------------------------------------------------------------
# Install https://github.com/krallin/tini - a very small 'init' process
# that helps processing signalls sent to the container properly.
# ---------------------------------------------------------------------

RUN apt-get update && \
    apt-get install -y curl jq && \
    curl -Lo /usr/local/bin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 && \
    chmod +x /usr/local/bin/tini

# --------------------------------------------------------------------------
# Install and configure sshd.
# https://docs.docker.com/engine/examples/running_ssh_service for reference.
# --------------------------------------------------------------------------
RUN apt-get install -y openssh-server && \
    # Creating /run/sshd instead of /var/run/sshd, because in the Debian
    # image /var/run is a symlink to /run. Creating /var/run/sshd directory
    # as proposed in the Docker documentation linked above just doesn't    # work.
    mkdir -p /run/sshd

EXPOSE 22

# ----------------------------------------
# Install GitLab CI required dependencies.
# ----------------------------------------
ARG GITLAB_RUNNER_VERSION

RUN curl -Lo /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/v${GITLAB_RUNNER_VERSION}/binaries/gitlab-runner-linux-amd64 && \
    chmod +x /usr/local/bin/gitlab-runner
    # Test if the downloaded file was indeed a binary and not, for example,
    # an HTML page representing S3's internal server error message or something
    # like that.

RUN apt-get install -y bash ca-certificates git git-lfs unzip && \
    git lfs install --skip-repo

RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip  && \
    unzip /tmp/awscliv2.zip && \
    ./aws/install && \
    rm /tmp/awscliv2.zip 
# -------------------------------------------------------------------------------------
# Execute a startup script.
# https://success.docker.com/article/use-a-script-to-initialize-stateful-container-data
# for reference.
# -------------------------------------------------------------------------------------
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["tini", "--", "/usr/local/bin/docker-entrypoint.sh"]



