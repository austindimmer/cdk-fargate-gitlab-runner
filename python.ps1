python --version 
# Python 3.9.6
pipenv --version
# pipenv, version 2021.5.29
pip3 --version
# pip 21.1.3

conda create -n gitlab python=3.9.7

conda init zsh
conda init pwsh
conda init powershell
conda init bash

conda activate gitlab


cd gitlab_ci_fargate_runner
pipenv install
pipenv shell
pip install -r requirements.txt
# start docker service , it is used to build image

pipenv run cdk synth  --all 
pipenv run cdk deploy --all

pipenv run cdk deploy -c DockerImageName=cdk -c Memory=2048 -c CPU=1024  cdkTaskDefinitionStack