#!/bin/sh
### Start of validation ###

# Check if AWS CLI version is 2.*
aws_version=$(aws --version 2>&1)
if [[ $aws_version != aws-cli/2* ]]; then
    echo "Error: AWS CLI version 2 is required"
    exit 0
fi
    
# if $1 does not exist or it's help
if [ -z "$1" ] || [ "$1" == "help" ]; then
    echo "Missing positional argument: -a or -account [number]"
    exit 0
fi

# Wrong args
if ! [[ "$1" == "-a" ]] || [[ "$1" == "-account" ]]; then
    echo "Only positional argument allowed: -a or -account [number]"
    exit 0
fi

# Correct args, account info is wrong
if ! [[ "$2" =~ ^[0-9]+$ ]]; then
    echo "The second argument needs to be an account number"
    exit 0
fi

# Couldn't set credentials
if [ "$AWS_ACCOUNT_ID" != "$2" ]; then
    echo "To export IAM data, you need to set the AWS_ACCOUNT_ID environment variable to $2"
    echo "Please run:"
    echo "gobbc aws-credentials -account $2" 
    exit 0
fi

### End of validation ###

# Make sure we're not saving anything corrupted
check_last_command() {
    if [ $? -ne 0 ]; then
        rm -rf "raw_$2"
        echo "Error: Failed to execute the last command: $cmd"
        exit 0
    fi
}

# Commands to execute
commands=(
    "aws iam list-users --output yaml > raw_$2/users.yaml"
    "aws iam list-groups --output yaml > raw_$2/groups.yaml"
    "aws iam list-roles --output yaml > raw_$2/roles.yaml"
    "aws iam list-policies --scope Local --output yaml > raw_$2/policies.yaml"
)

# Save all command data
mkdir "raw_$2"
for cmd in "${commands[@]}"; do
    echo $cmd
    eval $cmd
    check_last_command
done

# Save all user policies
mkdir "raw_$2/user_policies"
usernames=$(awk '/UserName:/ {print $2}' "raw_$2/users.yaml")
for username in $usernames; do
    eval "aws iam list-attached-user-policies --user-name $username --output yaml > raw_$2/user_policies/$username.yaml"
done


# Save policy details
mkdir "raw_$2/policy_statements"
arns=($(awk '/- Arn:/ {print $3}' "raw_$2/policies.yaml"))
versions=($(awk '/DefaultVersionId:/ {print $2}' "raw_$2/policies.yaml"))

for i in "${!arns[@]}"; do

    arn="${arns[$i]}"

    # IMPORTANT!! This doesn't work if there's a path in the name, needs more thinking
    name="${arn#*/}"
    eval "aws iam get-policy-version --policy-arn $arn --version-id  ${versions[$i]} --output yaml > raw_$2/policy_statements/$name.yaml"
done