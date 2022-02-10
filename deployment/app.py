#!/usr/bin/env python3

from aws_cdk import core as cdk

from _deployment._deployment_stack import MotivusMarketplaceApiStack

app = cdk.App()
env = cdk.Environment(account='522891085541', region='us-east-1')
MotivusMarketplaceApiStack(app, 'motivus-marketplace-api', env=env)

app.synth()
