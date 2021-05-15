#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { DbtAwsCdkStack } from '../lib/dbt-aws-cdk-stack';

const app = new cdk.App();
new DbtAwsCdkStack(app, 'DbtAwsCdkStack');
