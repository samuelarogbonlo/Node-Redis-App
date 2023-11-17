# Define variables for Terraform
TF          = terraform
TF_VPC_DIR  = terraform/vpc
TF_APP_DIR  = terraform/ecs

# Define the default target
.DEFAULT_GOAL := help

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  init_vpc                               - Initialize Terraform for the VPC configuration"
	@echo "  plan_vpc                               - Generate and show an execution plan for the VPC configuration"
	@echo "  apply_vpc                              - Apply the changes to the VPC configuration"
	@echo "  destroy_vpc                            - Destroy the Terraform-managed VPC infrastructure"
	@echo "  init_app                               - Initialize Terraform for the application configuration"
	@echo "  plan_app                               - Generate and show an execution plan for the application configuration"
	@echo "  apply_app                              - Apply the changes to the application configuration"
	@echo "  destroy_app                            - Destroy the Terraform-managed application infrastructure"
	@echo "  deploy_all                             - Deploy both VPC and application layers"
	@echo "  help                                   - Shows this help message"

deploy_all: init_vpc apply_vpc init_app apply_app

destroy_all: destroy_app destroy_vpc

init_vpc:
	@cd $(TF_VPC_DIR) && $(TF) init 

plan_vpc:
	@cd $(TF_VPC_DIR) && $(TF) plan -input=false

apply_vpc:
	@cd $(TF_VPC_DIR) && $(TF) apply -auto-approve -input=false

destroy_vpc:
	@cd $(TF_VPC_DIR) && $(TF) destroy -auto-approve -input=false

init_app:
	@cd $(TF_APP_DIR) && $(TF) init

plan_app:
	@cd $(TF_APP_DIR) && $(TF) plan -input=false

apply_app:
	@cd $(TF_APP_DIR) && $(TF) apply -auto-approve -input=false

destroy_app:
	@cd $(TF_APP_DIR) && $(TF) destroy -auto-approve -input=false
