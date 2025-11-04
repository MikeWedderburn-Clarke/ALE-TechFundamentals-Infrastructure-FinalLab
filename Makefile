.PHONY: help init plan apply deploy destroy clean validate format

# Default target
help:
	@echo "Available targets:"
	@echo "  init      - Initialize Terraform"
	@echo "  validate  - Validate Terraform configuration"
	@echo "  format    - Format Terraform files"
	@echo "  plan      - Create Terraform plan"
	@echo "  apply     - Apply Terraform configuration"
	@echo "  deploy    - Full deployment (init + apply + web deploy)"
	@echo "  destroy   - Destroy all infrastructure"
	@echo "  clean     - Remove local Terraform files"

# Initialize Terraform
init:
	terraform init

# Validate Terraform configuration
validate:
	terraform validate

# Format Terraform files
format:
	terraform fmt -recursive

# Create Terraform plan
plan: init
	terraform plan -out=tfplan

# Apply Terraform configuration
apply: init
	terraform apply tfplan

# Full deployment
deploy:
	@echo "Starting full deployment..."
	@./deploy.sh

# Destroy infrastructure
destroy:
	@echo "WARNING: This will destroy all infrastructure!"
	@read -p "Are you sure? Type 'yes' to confirm: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		terraform destroy; \
	else \
		echo "Destroy cancelled."; \
	fi

# Clean local files
clean:
	rm -rf .terraform/
	rm -f .terraform.lock.hcl
	rm -f tfplan
	rm -f terraform.tfstate*
	rm -f webapp.zip
	@echo "Cleaned local Terraform files"
