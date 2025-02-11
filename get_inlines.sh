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

# Delete inline policy
echo "Looking for file names in raw_$2/role_policies"
roles=$(ls "raw_$2/role_policies")

for role in $roles; do
    role=${role%.*}
    # Checking it's a bbc email
    if [[ $role == *"@"*  && $role == *"bbc"* ]]; then
        
        policies=$(eval "aws iam list-role-policies --role-name $role --output text")

        if [ -n "$policies" ]; then
            echo "$role"
            echo $policies
        else
            echo "No inline policies found for $role"
        fi

    fi
done

