environment         = "dev"
location            = "West Europe"
resource_group_name = "keycloak-resources"
vm_size             = "Standard_B1s"
admin_username      = "adminuser"
vm_name             = "keycloak-vm"
tags = {
  Environment = "dev"
  Project     = "keycloak"
  ManagedBy   = "terraform"
}