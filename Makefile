
.ONESHELL:
.SHELL := /bin/bash
.PHONY: publish

#MODULE_DIR := $$PWD/../../

#CLUSTER_NAME ?= integration-test
# CURRENT_DIR := $$PWD
# TEST_REPORT_DIR ?= $$PWD
# TF_WORKDIR := ./
# #EXTRA_TF_VARS := TF_VAR_cluster_name=$(CLUSTER_NAME)
# REGION ?= eu-central-1

# AWS_PROFILE ?= 
# DOCKER_ENV_VARS := REGION=$(REGION) AWS_PROFILE=$(AWS_PROFILE)
# DOCKER_WORK_DIR := /docker/
# DOCKER_FLAGS := -v $(MODULE_DIR):/docker  -v ~/.aws:/root/.aws \
#                 $(foreach var, $(EXTRA_TF_VARS) $(DOCKER_ENV_VARS), -e $(var)) --rm -it

# AWS := aws
# ifeq ($(LOCAL_MODE), true)
# 	TERRAFORM := docker run -v  ~/.terraform:/root/.terraform \
# 				   -v ~/.terraform.d:/root/.terraform.d \
# 				   -w $(DOCKER_WORK_DIR)/$(TF_WORKDIR) \
# 				   $(DOCKER_FLAGS) meteogroup/ci_utils:v4.0.0 terraform
# else
# 	TERRAFORM := $(EXTRA_TF_VARS) terraform -chdir=$(TF_WORKDIR)
# endif

# help:
# 	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# set-env:
# 	$(eval VARS:=./$(TF_WORKDIR)/input.auto.tfvars)
# 	$(eval ENV=$(shell sed 's/\ *=\ */=/g' $(VARS) | awk -F= '/^environment/{ gsub(/"/, "", $$2); print $$2}'))
# 	$(eval CLUSTER_GEN=$(shell sed 's/\ *=\ */=/g' $(VARS) | awk -F= '/^cluster_generation/{ gsub(/"/, "", $$2); print $$2}'))
# 	$(eval PROJECT=$(shell sed 's/\ *=\ */=/g' $(VARS) | awk -F= '/^business_unit/{ gsub(/"/, "", $$2); print $$2}'))
# 	$(eval REGION:=$(shell sed 's/\ *=\ */=/g' $(VARS) | awk -F= '/^region/{ gsub(/"/, "", $$2); print $$2}'))
# 	$(eval AWS_BACKEND_PROFILE:=$(shell sed 's/\ *=\ */=/g' $(VARS) | awk -F= '/^aws_profile_tf_backend/{ gsub(/"/, "", $$2); print $$2}'))
# 	$(eval AWS_PROFILE:=$(shell sed 's/\ *=\ */=/g' $(VARS) | awk -F= '/^aws_profile_tf_deploy/{ gsub(/"/, "", $$2); print $$2}'))
# 	$(eval S3_BUCKET:="dtn-tfbackend-project-$(PROJECT)")
# 	$(eval DYNAMODB_TABLE:="dtn-tfbackend-project-$(PROJECT)")
# 	$(eval CLUSTER_FULL_NAME:=$(CLUSTER_NAME)-$(CLUSTER_GEN))
# 	$(eval S3_KEY:="kubernetes-infrastructure/v1/$(ENV)/$(CLUSTER_FULL_NAME)/1/terraform.tfstate")
# 	$(eval PIPENV := CLUSTER_FULL_NAME=$(CLUSTER_FULL_NAME) \
# 			AWS_PROFILE=$(AWS_PROFILE) \
# 			REGION=$(REGION) \
# 			PIPENV_VENV_IN_PROJECT=1 pipenv)

IMAGE := intensivus/ci_utils:v1.0.0
WORKDIR ?= ./
CONTAINER_NAME := ci_utils

build:
	docker build -t $(IMAGE)  .

scan:
	docker scan --accept-license $(IMAGE)

test:
	docker run \
		-v $(WORK_DIR):/app \
		-w /app \
		-e CHEF_LICENSE="accept-no-persist" \
		--name ${CONTAINER_NAME} \
		--rm -i $(IMAGE) inspec exec -l debug test.rb
	

publish:
	printenv DOCKER_PASSWORD | docker login -u $(DOCKER_USERNAME) --password-stdin
	docker push $(IMAGE)
