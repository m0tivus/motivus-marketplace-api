#!/usr/bin/env python3

from aws_cdk import core

from main import MotivusMarketplaceApiStack

app = core.App()
env = core.Environment(account='522891085541', region='us-east-1')
MotivusMarketplaceApiStack(app, 'motivus-wb-marketplace-api', env=env)

app.synth()
