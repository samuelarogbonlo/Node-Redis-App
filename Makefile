# Define variables for Terraform
TF          = terraform
TF_VPC_DIR  = terraform/vpc
TF_APP_DIR  = terraform/ecs

# Define the default target
.DEFAULT_GOAL := help

# Targets that do not represent files
.PHONY: help init_all plan_all validate_all deploy_all destroy_all init_vpc plan_vpc apply_vpc destroy_vpc validate_vpc init_app plan_app apply_app destroy_app validate_app

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  init_all                               - Initialize Terraform for both VPC and application configurations"
	@echo "  plan_all                               - Generate and show execution plans for both VPC and application configurations"
	@echo "  validate_all                           - Validate both VPC and application Terraform configurations"
	@echo "  init_vpc                               - Initialize Terraform for the VPC configuration"
	@echo "  plan_vpc                               - Generate and show an execution plan for the VPC configuration"
	@echo "  apply_vpc                              - Apply the changes to the VPC configuration"
	@echo "  destroy_vpc                            - Destroy the Terraform-managed VPC infrastructure"
	@echo "  validate_vpc                           - Validate the VPC Terraform configuration"
	@echo "  init_app                               - Initialize Terraform for the application configuration"
	@echo "  plan_app                               - Generate and show an execution plan for the application configuration"
	@echo "  apply_app                              - Apply the changes to the application configuration"
	@echo "  destroy_app                            - Destroy the Terraform-managed application infrastructure"
	@echo "  validate_app                           - Validate the application Terraform configuration"
	@echo "  deploy_all                             - Deploy both VPC and application layers"
	@echo "  destroy_all                            - Destroy both VPC and application layers"
	@echo "  help                                   - Shows this help message"

init_all: init_vpc init_app

plan_all: plan_vpc plan_app

validate_all: validate_vpc validate_app

deploy_all: apply_vpc apply_app

destroy_all: destroy_app destroy_vpc

init_vpc:
	cd $(TF_VPC_DIR) && $(TF) init 

plan_vpc:
	cd $(TF_VPC_DIR) && $(TF) plan -input=false

apply_vpc:
	export TF_LOG=DEBUG && cd $(TF_VPC_DIR) && $(TF) apply -auto-approve -input=false

destroy_vpc:
	cd $(TF_VPC_DIR) && $(TF) destroy -auto-approve -input=false

validate_vpc:
	cd $(TF_VPC_DIR) && $(TF) validate -no-color

init_app:
	cd $(TF_APP_DIR) && $(TF) init

plan_app:
	cd $(TF_APP_DIR) && $(TF) plan -input=false

apply_app:
	export TF_LOG=DEBUG && cd $(TF_APP_DIR) && $(TF) apply -auto-approve -input=false

destroy_app:
	cd $(TF_APP_DIR) && $(TF) destroy -auto-approve -input=false

validate_app:
	cd $(TF_APP_DIR) && $(TF) validate -no-color
