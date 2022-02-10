import setuptools

with open("README.md") as fp:
    long_description = fp.read()

    setuptools.setup(
        name="motivus-marketplace-api-stack",
        version="1.0.0",

        description="Motivus marketplace CDK",
        long_description=long_description,
        long_description_content_type="text/markdown",

        author="Motivus SpA",

        package_dir={"": "_deployment"},
        packages=setuptools.find_packages(where="_deployment"),

        install_requires=[
            "aws-cdk.core",
            "aws-cdk.aws-s3",
            "aws-cdk.aws-ec2",
            "aws-cdk.aws-ecs",
            "aws-cdk.aws-ecs-patterns",
            "aws-cdk.aws-ecr",
            "aws-cdk.aws-iam",
            "aws-cdk.aws-rds",
            "aws-cdk.aws-secretsmanager",
            "aws-cdk.aws-route53",
            "aws-cdk.aws-certificatemanager",
        ],

        python_requires=">=3.7",

        classifiers=[
            "Programming Language :: Python :: 3.7",
            "Topic :: Software Development :: Code Generators",
        ],
    )
