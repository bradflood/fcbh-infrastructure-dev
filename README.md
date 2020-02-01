# fcbh-infrastructure-dev
Development terragrunt for FCBH modules

status Jan 26
the s3 bucket used to store terraform state is being created in the default account, not where we intend it to be created. 
somehow the account needs to be specified, and the account is not assumed or derived from the aws_profile
terragrunt has a new method for storing common information (post terraform 0.12), using yaml instead of tfvars files

Update Feb1
Need to migrate to this setting an IAM role as part of terragrunt execution, as described here:
https://davidbegin.github.io/terragrunt/use_cases/work-with-multiple-aws-accounts.html
I now think all the terraform state should be in the master account
```
export TERRAGRUNT_IAM_ROLE="arn:aws:iam::970273885721:role/contributor_kh_admin"
```

```
export TG_BUCKET_PREFIX="-brad"
```

The code in this repo uses the following folder hierarchy:


```
dev-account-1
 └ _global
 └ us-east-2
    └ _global
    └ prod
       └ vpc
       └ bastion
       └ rds
```

don't use terragrunt -all commands. Here is why: https://github.com/gruntwork-io/terragrunt/issues/720