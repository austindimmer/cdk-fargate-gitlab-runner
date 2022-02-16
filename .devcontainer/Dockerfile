# https://github.com/microsoft/vscode-dev-containers/tree/main/containers/python-3-anaconda

FROM continuumio/anaconda3

# Copy library scripts to execute
# Good source for library install scripts
# https://github.com/microsoft/vscode-dev-containers
# https://github.com/microsoft/vscode-dev-containers/tree/main/script-library
WORKDIR /tmp/library-scripts
COPY .devcontainer/library-scripts/*.sh /tmp/library-scripts

# convert line endings just in case
RUN ls
# RUN sed -i -e 's/\r\+$//' **/*.sh
WORKDIR /
# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"
# [Option] Enable non-root Docker access in container
ARG ENABLE_NONROOT_DOCKER="true"
# [Option] Use the OSS Moby Engine instead of the licensed Docker Engine
ARG USE_MOBY="true"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=node
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# 2>&1 is used to redirect stderr to std out which is useful to suppresss warnings we are not too woried about in VSCode terminal during docker build

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && bash /tmp/library-scripts/powershell-debian-alt.sh 2>&1 \
    # Use Docker script from script library to set things up
    && /bin/bash /tmp/library-scripts/docker-in-docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "${USERNAME}" "${USE_MOBY}" \
    && /bin/bash /tmp/library-scripts/kubectl-helm-debian.sh "latest" "latest" "latest" \
    && mkdir -p /home/${USERNAME}/.minikube \
    && chown ${USERNAME} /home/${USERNAME}/.minikube \
    && bash /tmp/library-scripts/github-debian.sh \
    && bash /tmp/library-scripts/terraform-debian.sh 2>&1 \
    && bash /tmp/library-scripts/aws-cli.sh 2>&1 \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \
    PATH=${NVM_DIR}/current/bin:${PATH}
RUN bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*


RUN pip3 install aws-sam-cli 2>&1
RUN pip3 install pipenv 2>&1
# Install global node modules
RUN su node -c "npm install -g pnpm@6.31.0" 2>&1
RUN su node -c "npm install -g aws-cdk@2.12.0" 2>&1
RUN su node -c "npm install -g snyk" 2>&1
RUN su node -c "npm install -g npm-upgrade" 2>&1
RUN su node -c "npm install -g @mhlabs/cfn-diagram" 2>&1
RUN su node -c "npm install -g cdk-dia" 2>&1


# Using a credential helper
# If you use HTTPS to clone your repositories and have a credential helper configured in your local OS, no further setup is required. Credentials you've entered locally will be reused in the container and vice versa.
# https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git

# https://code.visualstudio.com/docs/remote/containers-advanced#_adding-a-nonroot-user-to-your-dev-container


RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $USERNAME /commandhistory \
    && echo $SNIPPET >> "/home/$USERNAME/.bashrc"

RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
        /home/$USERNAME/.vscode-server-insiders/extensions \
        /home/$USERNAME/.aws \
    && chown -R $USERNAME \
        /home/$USERNAME/.vscode-server \
        /home/$USERNAME/.vscode-server-insiders \
        /home/$USERNAME/.aws

RUN mkdir -p /opt/conda/pkgs/ \
    && chown -R $USERNAME \
        /opt/conda/pkgs

# Remove library scripts for final image
RUN rm -rf /tmp/library-scripts

# Copy environment.yml (if found) to a temp locaition so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
COPY environment.yml* .devcontainer/noop.txt /tmp/conda-tmp/
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp

# RUN conda install -y python=3.10

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends tree mc graphviz

VOLUME [ "/var/lib/docker" ]

COPY .devcontainer/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
# Setting the ENTRYPOINT to docker-init.sh will start up the Docker Engine 
# inside the container "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]



