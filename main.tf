# ---------- # ---------- # ---------- # ----------
# Azure Provider Configuration
# ---------- # ---------- # ---------- # ----------
provider "azurerm" {
  features {}
}

# ---------- # ---------- # ---------- # ----------
# Infra Setup for Networking
# ---------- # ---------- # ---------- # ----------
# Virtual Network
resource "azurerm_virtual_network" "custom_vnet" {
  name                = var.custom_vnet_name
  address_space       = [var.address_space]
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.main.name
}

# Subnets
resource "azurerm_subnet" "db_subnet" {
  name                 = var.db_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.custom_vnet.name
  address_prefixes     = [var.db_cidr]
}

resource "azurerm_subnet" "webapp_subnet" {
  name                 = var.webapp_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.custom_vnet.name
  address_prefixes     = [var.webapp_cidr]
}

resource "azurerm_subnet" "proxy_subnet" {
  name                 = var.proxy_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.custom_vnet.name
  address_prefixes     = [var.proxy_cidr]
}

# ---------- # ---------- # ---------- # ----------
# Infra Setup for Firewall and Routing
# ---------- # ---------- # ---------- # ----------
# Network Security Group (Firewall Rules)
resource "azurerm_network_security_group" "webapp_nsg" {
  name                = var.webapp_nsg_name
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "AllowSSH"
  resource_group_name         = azurerm_resource_group.main.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.webapp_nsg.name
}

# Route Table
resource "azurerm_route_table" "main_route_table" {
  name                = var.route_table_name
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_route" "internet_route" {
  name                = "InternetRoute"
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
  route_table_name    = azurerm_route_table.main_route_table.name
  resource_group_name = azurerm_resource_group.main.name
}

# Associate Route Table with Subnets
resource "azurerm_subnet_route_table_association" "db_route" {
  subnet_id      = azurerm_subnet.db_subnet.id
  route_table_id = azurerm_route_table.main_route_table.id
}

resource "azurerm_subnet_route_table_association" "webapp_route" {
  subnet_id      = azurerm_subnet.webapp_subnet.id
  route_table_id = azurerm_route_table.main_route_table.id
}

# ---------- # ---------- # ---------- # ----------
# Infra Setup for Load Balancer
# ---------- # ---------- # ---------- # ----------
resource "azurerm_public_ip" "lb_ip" {
  name                = var.lb_ip_name
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "load_balancer" {
  name                = var.lb_name
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.main.name
  frontend_ip_configuration {
    name                 = "FrontendConfig"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = var.lb_rule_name
  loadbalancer_id                = azurerm_lb.load_balancer.id
  protocol                       = "Tcp"
  frontend_port                  = var.lb_frontend_port
  backend_port                   = var.lb_backend_port
  frontend_ip_configuration_name = "FrontendConfig"
}

# ---------- # ---------- # ---------- # ----------
# Infra Setup for Database (PostgreSQL)
# ---------- # ---------- # ---------- # ----------
resource "azurerm_postgresql_flexible_server" "db_server" {
  name                   = var.db_server_name
  location               = var.azure_region
  resource_group_name    = azurerm_resource_group.main.name
  version                = "12"
  sku_name               = var.db_sku_name
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  storage_mb             = var.db_storage_mb

  delegated_subnet_id = azurerm_subnet.db_subnet.id
}

resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.db_server.id
}

# ---------- # ---------- # ---------- # ----------
# Additional Azure Resources and IAM Bindings
# ---------- # ---------- # ---------- # ----------
# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.azure_region
}
