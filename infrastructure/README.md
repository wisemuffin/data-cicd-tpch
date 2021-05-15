# CDK role, and users for DBT

## TODO

sts:TagSession added manually to the role

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sts:AssumeRole",
                "sts:TagSession"
            ],
            "Resource": "arn:aws:",
            "Effect": "Allow"
        }
    ]
}
```

## Useful commands

 * `npm run build`   compile typescript to js
 * `npm run watch`   watch for changes and compile
 * `npm run test`    perform the jest unit tests
 * `cdk deploy`      deploy this stack to your default AWS account/region
 * `cdk diff`        compare deployed stack with current state
 * `cdk synth`       emits the synthesized CloudFormation template


## checking sts assume role

```bash
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

aws sts get-caller-identity


aws sts assume-role --role-arn 'arn:aws'

{
    "Credentials": {
    },
    "AssumedRoleUser": {

    }
}

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=""

aws sts get-caller-identity


unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN


aws s3 cp ./target/manifest.json s3://dbt-tutorial-sf/prod/manifest/manifest.json
aws s3 cp s3://dbt-tutorial-sf/prod/manifest/manifest.json ./target/last_manifest.json
```