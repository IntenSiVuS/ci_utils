# docker-ci-utils

In here belong simple tools, e.g. `awscli`, `terraform`, without an official docker
image as well as extensions / modifications of official images.
Larger projects should get their own git repositories.


#### Table of Contents
* [Usage](#usage)
* [Tools](#tools)
* [Development](#development)
  * [Requirements](#requirements)
  * [Testing](#testing)
  * [Code Organization](#code-organization)


## Usage

To use this, eithe ruse the options available in the makefile on it's own, or if you want to build, test and publish the image, just run build.sh
## Tools
* [docker]
  * Docker, to build image within this image (dind)
* [awscli]
  * The [AWS CLI](https://docs.aws.amazon.com/cli/latest/reference) to interact with the AWS service APIs
* [boto3]
  * [Boto 3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html), the Python AWS SDK
* [pyhcl]
  * [Pyhcl](https://github.com/virtuald/pyhcl) Read terraform tfvars using python
* [hub]
  * [Git hub CLI](https://hub.github.com/) To automate git things
* [terraform]
  * [Terraform](https://www.terraform.io/docs/index.html), a popular infrastructure provisioning tool
  

## Development

### Requirements

* only text editor & git client

### Testing

You need to write testcases using [InSpec](http://inspec.io) auditing and
testing framework. Just create `test.rb` in the project directory.
Run `inspec exec test.rb -t docker://<container_id>` to test.

### Code Organization

* `Dockerfile` - Main dockerfile which include all common packages 
* `test.rb` - test cases using InSpec

### TODO / Improvements

* Currently a third part dind image is used. The Dockerfile was checked, and it looks ok, but ideally build it form scratch myself, or use the official docker dind image which is Alpine based. That gives a challange with installing Chef Inspec as that uses apk instead of apt-get to install packages