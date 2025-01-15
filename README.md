# Dependencies

1. Python 3 
2. gobbc

# Execution

1. gobbc aws-credentials -account 528761583664
2. bash backup.sh -a 528761583664

This will create the following:
.
├── README.md
├── backup.sh
├── raw_528761583664
│   ├── groups.yaml
│   ├── policies.yaml
│   ├── roles.yaml
│   ├── users.yaml
│   ├── policy_statements
│   │   ├── AWSCloudFormationPCSOPS.yaml
│   │   ├── ...
│   ├── policy_statements
│   │   ├── AWSCloudFormationPCSOPS.yaml
│   │   ├── ...
│   ├── role_policies
│   │   ├── name.surname@bbc.co.uk.yaml
│   │   ├── ...
│   ├── user_policies
│   │   ├── modav.Name_Surname.yaml
│   │   ├── ...
