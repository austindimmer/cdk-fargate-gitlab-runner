#!/bin/bash

function install_aws_cli() {
    gpg --import AwsCliPgpSignature.pub
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    curl -o awscliv2.sig https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig
    gpg --verify awscliv2.sig awscliv2.zip
    unzip -o -q awscliv2.zip
    sudo ./aws/install --update

    echo "Finished installing AWS CLI..."
    echo 
    echo "Installed AWS CLI Version"
    echo 
    aws --version
    echo 
    echo "which aws"
    echo 
    which aws

   if [ $1 > "0" ]
   then
       return 1
   else
       return 0
   fi
 }

install_aws_cli




