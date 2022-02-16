cd /workspaces/cdk-fargate-gitlab-runner/docker_images/cdk
docker build . --build-arg GITLAB_RUNNER_VERSION=14.7.0


# https://stackoverflow.com/questions/62473932/atleast-one-invalid-signature-was-encountered
docker image prune -f
docker container prune -f
docker system prune
docker system df
docker builder prune
docker image prune -a

