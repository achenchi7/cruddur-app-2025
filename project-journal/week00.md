# Week 00 - Preparing your working environment

This initial step is a crucial one in setting up your environment to execute the project successfully. 

## Pre-requisite
1. Create an AWS Account
2. Create an IAM user within your acciunt and grant administrative privileges.
3. Generate an Access key and a Secret Key for your IAM account for programmatic access.

## Requirements
1. Install the AWS CLI
2. Set environment variables
2. Set up billing and budgets using the AWS CLI
3. Configure Gitpod


### 1. Install the AWS CLI
Use the folloeing commands to install AWS CLI on Linux in Gitpod
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
`-o "awscliv2.zip` saves the downloaded file with that name.

To verify that the installation was successful, run `aws --version`

### 2. Set environment variables
Environment variables are key-value pairs that we will use throughout the project.

```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION=us-east-1
```

Gitpod is an ephemeral environment which means that whenever you exit Gitpod, your environment variables disappear as well. To ensure that your environment variables persist, run:

```
gp env AWS_ACCESS_KEY_ID=""
gp env AWS_SECRET_ACCESS_KEY=""
gp env AWS_DEFAULT_REGION=us-east-1
```

To ensure that everything has been set correctly, run the following command:
```
aws sts get-caller-identity
```
You should see something like this:
```
{
    "UserId": "AIFBZP4ET4EKRJIQN2ON4",
    "Account": "655602346535",
    "Arn": "arn:aws:iam::655602346535:user/cruddur-project"
}
```

### 3. Set up billing and budgets using the AWS CLI

#### 3.1 Enable billing
Turn on billing Alerts to receive alerts. This is done in your root account.

### 3.2 Create a Billing Alarm

#### 3.2.1 Create an SNS topic
Create an SNS topic before creating the alarm. The SNS topic is what will deliver an alert if you exceed your budget.

To create an SNS topic:
```
aws sns create-topic --name cruddur-alarm
```
This will return a topicARN (Amazon Resource Name)

Create a subscription to the topic using your email address

```
aws sns subscribe \
    --topic-arn <topicARN> \
    --protocol email \
    --notification-endpoint <youremail@example.com>
```
Check your email and confirm the subscription.

#### 3.3 Create an alarm
- You can now create an alarm.
- Create a [JSON file](/workspace/x-clone-deployment-start-to-finish/step_0/json-files/cloudwatch_alarm_config.json) and configure the alarm description and desired metrics. 
- Run the following command to create the alarm

```
aws cloudwatch put-metric-alarm --cli-input-json file://step_0/json-files/cloudwatch_alarm_config.json
```

### 3.4 Create an AWS Budget
- Programmatically get your AWS Account ID
```
aws sts get-caller-identity --query Account --output text
```
- Supply your AWS Account ID
- Update the json files

```
aws budgets create-budget \
    --account-id AccountID \
    --budget file://aws/json/budget.json \
    --notifications-with-subscribers file://aws/json/budget-notifications-with-subscribers.json
```

### 4. Configure Gitpod 
Gitpod is a cloud-based ephemeral development environment that can be spun up on demand and released after use. 

Gitpod will be largely used throughout the project. The free tier that Gitpod provides will be sufficient for this project.

Gitpod is configured in the `.gitpod.yml`. file. The .gitpod.yml file instructs Gitpod on how to prepare and build the project environment, such as starting development servers and configuring Prebuilds

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