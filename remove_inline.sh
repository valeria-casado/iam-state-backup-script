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
    fi
}

# Delete inline policy
echo "Looking for file names in raw_$2/role_policies"
roles=$(ls "raw_$2/role_policies")

for role in $roles; do
    role=${role%.*}
    # Checking it's an email
    if [[ $role == *"@"* ]]; then
        echo "$role"
        eval "aws iam delete-role-policy --role-name $role --policy-name ChangeCorrespondingUsersPasswordAndMFA"
    fi
done

echo "Deleted inline policy for roles above if they contained a policy named ChangeCorrespondingUsersPasswordAndMFA"
