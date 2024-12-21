# ---------- # ---------- # ---------- # ----------
# Variables Definitions
# ---------- # ---------- # ---------- # ----------

# Azure Region
variable "azure_region" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "us-east1"
}

# Resource Group
variable "resource_group_name" {
  description = "Name of the resource group to create."
  type        = string
}

# Virtual Network
variable "custom_vnet_name" {
  description = "Name of the virtual network."
  type        = string
  default     = "custom-vpc"
}

variable "address_space" {
  description = "CIDR block for the virtual network."
  type        = string
}

# Subnets
variable "db_subnet_name" {
  description = "Name of the database subnet."
  type        = string
  default     = "db-subnet"
}

variable "webapp_subnet_name" {
  description = "Name of the web application subnet."
  type        = string
  default     = "webapp-subnet"
}

variable "proxy_subnet_name" {
  description = "Name of the proxy subnet."
  type        = string
  default     = "proxy-only-subnet"
}

variable "db_cidr" {
  description = "CIDR block for the database subnet."
  type        = string
  default     = "10.1.1.0/24"
}

variable "webapp_cidr" {
  description = "CIDR block for the web application subnet."
  type        = string
  default     = "10.1.2.0/24"
}

variable "proxy_cidr" {
  description = "CIDR block for the proxy subnet."
  type        = string
  default     = "10.129.0.0/24"
}

# Network Security Group
variable "webapp_nsg_name" {
  description = "Name of the web application network security group."
  type        = string
}

# Route Table
variable "route_table_name" {
  description = "Name of the route table."
  type        = string
  default     = "network-route"
}

# Load Balancer
variable "lb_ip_name" {
  description = "Name of the public IP for the load balancer."
  type        = string
  default     = "lb-ip-addr"
}

variable "lb_name" {
  description = "Name of the load balancer."
  type        = string
}

variable "lb_rule_name" {
  description = "Name of the load balancer rule."
  type        = string
  default     = "lb-mapping"
}

variable "lb_frontend_port" {
  description = "Frontend port for the load balancer."
  type        = number
  default     = 443
}

variable "lb_backend_port" {
  description = "Backend port for the load balancer."
  type        = number
  default     = 8080
}

# PostgreSQL Database
variable "db_server_name" {
  description = "Name of the PostgreSQL server."
  type        = string
}

variable "db_name" {
  description = "Name of the PostgreSQL database."
  type        = string
  default     = "webapp"
}

variable "db_sku_name" {
  description = "SKU name for the PostgreSQL server."
  type        = string
}

variable "db_admin_username" {
  description = "Admin username for the PostgreSQL server."
  type        = string
  default     = "webapp"
}

variable "db_admin_password" {
  description = "Admin password for the PostgreSQL server."
  type        = string
  sensitive   = true
}

variable "db_storage_mb" {
  description = "Storage size in MB for the PostgreSQL server."
  type        = number
  default     = 100
}

# ---------- # ---------- # ---------- # ----------
# End of Variables Definitions
# ---------- # ---------- # ---------- # ----------
