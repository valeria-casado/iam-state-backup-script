# Dependencies

1. Python 3 
2. gobbc


# IMPORTANT


***policies.yaml contains non-default policies***

***role_policies contains only managed policies, not inline policies***

[Managed vs inline](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html)


# Execution

1. gobbc aws-credentials -account 528761583664
2. bash backup.sh -a 528761583664

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