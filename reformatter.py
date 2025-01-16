import sys
from yaml import load, dump, safe_load
import os
import re
from datetime import datetime

### Parser functions ###

def is_valid_utf_format(date_string):
    try:
        datetime.strptime(date_string, '%Y-%m-%dT%H:%M:%S%z')
        return date_string[:10]
    except ValueError:
        return None

def transform_policy(account_number, policy_name):

    # Check that both of these files exists
    # Only really need the role policy one, but for general health
    check_exists(f'./raw_{account_number}/policies.yaml')
    check_exists(f'./raw_{account_number}/policy_statements/{policy_name}.yaml')
        
    with open(f"./raw_{account_number}/policy_statements/{policy_name}.yaml", 'r') as stream:
        og_policy = safe_load(stream)

    """
    https://github.com/bbc/aws-access/blob/main/policies/tvr-syseng-prod/example-policy.yml

    Description: >
        A CloudFormation template used to demonstrate how to create IAM policies using the iPlayer & Sounds AWS Access policy manager.
    Resources:
    CreateTestDBPolicy:
        Type: AWS::IAM::ManagedPolicy
        Properties:
        Description: Policy to grant read access to the CloudFormation S3 bucket in the tvr-syseng-prod AWS account. Used as an example only.
        ManagedPolicyName: PolicyManagerExamplePolicy
        PolicyDocument:
            Version: 2012-10-17
            Statement:
            - Sid: GrantReadAccessToCloudFormationBucket
                Effect: Allow
                Action: 
                - s3:GetObject
                - s3:GetObjectAcl
                Resource: arn:aws:s3:::cf-templates-1u30e4bvkymdj-eu-west-1/*
    
    """

    CreateTestDBPolicy = ''.join(['Create'] + [word.title() for word in policy_name.split('-')])

    valid_date = is_valid_utf_format(og_policy['PolicyVersion']['CreateDate'])

    print(og_policy['PolicyVersion']['Document']['Statement'])

    dst_policy = {
        'AWSTemplateFormatVersion': og_policy['PolicyVersion']['Document']['Version'],
        'Resources': {
            CreateTestDBPolicy: {
                'Type': 'AWS::IAM::ManagedPolicy',
                'Properties': {
                    'Description': 'PLEASE COMPLETE',
                    'ManagedPolicyName': policy_name,
                    'PolicyDocument': {
                        'Version': valid_date if valid_date else 'PLEASE COMPLETE',
                        'Statement': [
                            {
                                'Sid': statement.get('Sid', 'PLEASE COMPLETE'),
                                'Effect': statement['Effect'],
                                'Action': statement['Action'],
                                'Resource': statement['Resource']
                            } for statement in og_policy['PolicyVersion']['Document']['Statement']
                        ]
                    }
                }
            }
        }
    }
    
    # Transform the dictionary into a YAML file
    output_path = f"{CreateTestDBPolicy[6:]}.yaml"
    with open(output_path, 'w') as outfile:
        dump(dst_policy, outfile, default_flow_style=False)

def check_exists(path) -> bool:
    exists = os.path.exists(path)
    if not exists:
        print(f'Path {path} not found in root directory.')
        sys.exit(1)
    else: return True
    
### End of parser functions ###

def main():
    if len(sys.argv) != 4:
        print("Usage: reformatter.py <account_number> [args]")
        print("Args: -policy -p [policyName] OR -account -a [accountName]")
        sys.exit(1)

    account_number = sys.argv[1]
    option = sys.argv[2]

    if option == '-policy' or option == '-p':
        policy_name = sys.argv[3]

        if 'yaml' in policy_name:
            policy_name = policy_name[:-5]

        print("Transforming policy...")
        transform_policy(account_number, policy_name)

    else:
        print("Invalid option. Use -policy or -p")
        sys.exit(1)

if __name__ == "__main__":
    main()