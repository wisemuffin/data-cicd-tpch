import * as cdk from '@aws-cdk/core';
import { Role, User, Group, ServicePrincipal, PolicyStatement, Policy, CfnAccessKey } from '@aws-cdk/aws-iam'
import { Bucket } from '@aws-cdk/aws-s3'

export class DbtAwsCdkStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // The code that defines your stack goes here

    const bucket = new Bucket(this, 'DbtTutorialSfBucket', { bucketName: 'dbt-tutorial-sf' })

    const user = new User(this, 'MyUser', {
      userName: 'dbt-tutorial-github-action'
    });


    const accessKey = new CfnAccessKey(this, 'myAccessKey', {
      userName: user.userName,
    });

    const accessKeyId = new cdk.CfnOutput(this, "AccessKeyId", {
      value: accessKey.ref,
    });

    const accessKeySecret = new cdk.CfnOutput(this, "SecretAccessKeyId", {
      value: accessKey.attrSecretAccessKey,
    });

    const role = new Role(this, 'MyRole', {
      assumedBy: user,

    });


    const policy_sts = new Policy(this, 'dbt-tutorial-sf-sts');
    policy_sts.addStatements(new PolicyStatement({
      resources: [role.roleArn],
      actions: [
        "sts:AssumeRole",
        "sts:TagSession"
      ],
    }))
    user.attachInlinePolicy(policy_sts)





    const policy = new Policy(this, 'dbt-tutorial-sf-s3');
    policy.addStatements(new PolicyStatement({
      resources: [`${bucket.bucketArn}/*`],
      actions: ['s3:GetObject', "s3:PutObject", "s3:DeleteObject"],
    }))
    policy.attachToRole(role);


  }
}
