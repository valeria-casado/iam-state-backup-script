
# IMPORTANT


***policies.yaml contains non-default policies***

***role_policies contains only managed policies, not inline policies***

[Managed vs inline](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html)


# Dependencies

1. gobbc


# Execute backup

1. `gobbc aws-credentials -account 528761583664`
2. `bash backup.sh -a 528761583664`

This will create the following:

```
.
├── README.md
├── backup.sh
├── raw_accountnumber
│   ├── groups.yaml
│   ├── policies.yaml
│   ├── roles.yaml
│   ├── users.yaml
│   ├── policy_statements
│   │   ├── NONDEFAULTPOLICY.yaml
│   │   ├── ...
│   ├── role_policies
│   │   ├── name.surname@bbc.co.uk.yaml
│   │   ├── ...
│   ├── user_policies
│   │   ├── modav.Name_Surname.yaml
│   │   ├── ...

```

# Sample backup output

`policy_statemets/policy.yaml`

```
PolicyVersion:
  CreateDate: '2017-08-10T11:26:29+00:00'
  Document:
    Statement:
    - Action:
      - cloudformation:DescribeStacks
      - cloudformation:DescribeStackEvents
      - cloudformation:DescribeStackResource
      - cloudformation:DescribeStackResources
      - cloudformation:GetTemplate
      - cloudformation:List*
      - cloudformation:CreateStack
      - cloudformation:UpdateStack
      - ec2:*
      Effect: Allow
      Resource: '*'
    Version: '2012-10-17'
  IsDefaultVersion: true
  VersionId: v4
```

`role_policies/role.yaml`

```
AttachedPolicies:
- PolicyArn: arn:aws:iam::528761583664:policy/ModavJmlResources-ModavModavDevPolicy-12V8J3OJ9JAOB
  PolicyName: ModavJmlResources-ModavModavDevPolicy-12V8J3OJ9JAOB
- PolicyArn: arn:aws:iam::528761583664:policy/ModavJmlResources-ModavReadonlyPolicy-11OAFLW96I0N0
  PolicyName: ModavJmlResources-ModavReadonlyPolicy-11OAFLW96I0N0
- PolicyArn: arn:aws:iam::528761583664:policy/ModavJmlResources-ModavSupportPolicy-11PTAVAMVWVAN
  PolicyName: ModavJmlResources-ModavSupportPolicy-11PTAVAMVWVAN
```

# Reformat policy

1. Create python environment
2. Install requirements
3. `python3 reformatter.py <account number> -p <policy name as seen on filename>`

# Remove default inline policies
You can omit step 2 if it's done.

1. `gobbc aws-credentials -account 528761583664`
2. `bash backup.sh -a 528761583664`
3. `bash remove_inline.sh -a 528761583664`
4. Check accounts manually


# Get all inline policies
You can omit step 2 if it's done.

1. `gobbc aws-credentials -account 528761583664`
2. `bash backup.sh -a 528761583664`
3. `bash get_inlines.sh -a 528761583664`