# Week 00 - Preparing your working environment

This initial step is a crucial one in setting up your environment to execute the project successfully. 

## Pre-requisite
1. Create an AWS Account
2. Create an IAM user within your acciunt and grant administrative privileges.
3. Generate an Access key and a Secret Key for your IAM account for programmatic access.

## Requirements
1. Configure Gitpod
2. Install the AWS CLI
3. Set up billing and budgets using the AWS CLI

### 1. Install the AWS CLI
Use the folloeing commands to install AWS CLI on Linux in Gitpod
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### 1. Configure Gitpod 
Gitpod is a cloud-based ephemeral development environment that can be spun up on demand and released after use. 

Gitpod will be largely used throughout the project. The free tier that Gitpod provides will be sufficient for this project.

Gitpod is configured in the `.gitpod.yml`. file The .gitpod.yml file instructs Gitpod on how to prepare and build a project, such as starting development servers and configuring Prebuilds

**Gitpod configuration code**
```yml

tasks:
  - name: aws-cli
    command: |
      if ! command -v aws &> /dev/null; then
        echo "Installing AWS CLI..."
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip -o awscliv2.zip
        sudo ./aws/install
        rm -rf awscliv2.zip aws
        echo "AWS CLI installed and the zip file deleted"
      else
        echo "AWS CLI already installed."
      fi

      aws --version

      ### Add auto-prompt to shell config if not already added
      
      if ! grep -q "AWS_CLI_AUTO_PROMPT=on-partial" ~/.bashrc; then
        echo 'export AWS_CLI_AUTO_PROMPT=on-partial' >> ~/.bashrc
      fi

      export AWS_CLI_AUTO_PROMPT=on-partial  # For current shell
      echo "Auto-prompt is set to: $AWS_CLI_AUTO_PROMPT"
      aws --version

vscode:
  extensions:
    - ms-azuretools.vscode-docker
```