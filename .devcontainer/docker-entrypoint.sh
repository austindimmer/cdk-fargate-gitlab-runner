#!/usr/env bash

echo "Hello from our devcontainer entrypoint!"

# docker-init.sh will start up the Docker Engine 

# . /usr/local/share/docker-init.sh

sudo git config --global core.autocrlf input

# pnpm install
# pnpm run test

mkdir -p /home/node/.aws
ln -s /home/node/.aws /workspaces/cdk-fargate-gitlab-runner/.aws
touch /home/node/.aws/credentials
sudo chmod -R 765 /home/node/.aws
sudo chown -R node /home/node/.aws
cat <<EOF > /home/node/.aws/credentials
[default]
sso_start_url = https://111111111111111.signin.aws.amazon.com/console
sso_region = eu-west-1
sso_account_id = 111111111111111
sso_role_name = AWSAdministratorAccess
region = eu-west-1
output = json
EOF

cat <<EOF > /home/node/.aws/config
[default]
output=json
region = eu-west-1
EOF
mkdir -p /workspaces/cdk-fargate-gitlab-runner/build
sudo chown -R node /workspaces/cdk-fargate-gitlab-runner/build
mkdir -p /workspaces/cdk-fargate-gitlab-runner/.pnpm-store
sudo chown -R node /workspaces/cdk-fargate-gitlab-runner/.pnpm-store
mkdir -p /workspaces/cdk-fargate-gitlab-runner/node_modules
sudo chown -R node /workspaces/cdk-fargate-gitlab-runner/node_modules
mkdir -p /workspaces/cdk-fargate-gitlab-runner/node_modules/.pnpm/
sudo chown -R /workspaces/cdk-fargate-gitlab-runner/node_modules/.pnpm/
mkdir -p /workspaces/cdk-fargate-gitlab-runner/declarations
sudo chown -R node /workspaces/cdk-fargate-gitlab-runner/declarations


exec "$@"