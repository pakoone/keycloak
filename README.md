Infrastructure Components Choice:

Using Azure VM instead of AKS (Azure Kubernetes Service) because:

Single-node deployment doesn't require orchestration complexity
Cost-effective for small deployments
Simpler maintenance and configuration


Standard_B1s VM size chosen for:

Sufficient resources for containers
Cost-effective for development/testing
1 vCPUs and 1GB RAM adequate for Keycloak + Postgres




Container Environment:

Using Docker and Docker Compose instead of Kubernetes because:

Simpler deployment for small number of containers
Easy configuration and maintenance
Built-in container networking
Straightforward volume management




Image Choices:

keycloak_version: "23.0.1"

Official image with regular security updates
Well-documented and maintained


Postgres: postgres:15-alpine

Stable version with long-term support
Proven reliability with Keycloak


Nginx: nginx:alpine

Lightweight image for static content
Minimal attack surface




Network Configuration:

Private subnet (10.0.2.0/24) for internal communication
NSG rules only allowing necessary ports (22, 80, 443)
Docker bridge network for container isolation
Public IP for external access


Automation & CI/CD:

GitHub Actions for automated deployment/destruction
Terraform for infrastructure provisioning
Ansible for configuration management
Separation of concerns between infrastructure and configuration


Potential Extensions:

a. Security Enhancements:

SSL/TLS certificates with Let's Encrypt
Azure Key Vault integration
Network security hardening

b. Monitoring & Logging:

Azure Monitor integration
Log Analytics workspace
Container monitoring

c. High Availability:

Multi-VM setup
Load balancer implementation
Database replication

d. Backup & Disaster Recovery:

Automated backups
Disaster recovery plan
Geographic redundancy




# Install required tools


# For Ubuntu
sudo apt install terraform 
sudo apt install anisble
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Login to Azure
az login

# Initialize Terraform
cd terraform
terraform init


Variables in GitHub secret:

 ARM_CLIENT_ID="client_id"
 ARM_CLIENT_SECRET="client_secret"
 ARM_SUBSCRIPTION_ID="subscription_id"
 ARM_TENANT_ID="tenant_id"
 ADMIN_PRIVATE_KEY="private_key"
 POSTGRES_PASSWORD="postgres_password"
 KEYCLOAK_PASSWORD="your_keycloak_password"



# Deploy infrastructure
cd terraform
terraform init
terraform plan
terraform apply

# Configure VM
cd ../ansible
ansible-playbook -i inventory.yml playbook.yml




