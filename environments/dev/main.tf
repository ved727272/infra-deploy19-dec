module "rg" {
  source = "../../modules/azurerm_resource_group"
  rgs    = var.rgs
}

module "pip" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_public_ip"
  pips       = var.pips
}

module "networks" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_networking"
  vnets      = var.vnets
}

module "vms" {
  depends_on = [module.rg, module.networks, module.pip]
  source     = "../../modules/azurerm_compute"
  vms        = var.vms
}
# module "key_vault" {
#   depends_on = [module.rg]
#   source     = "../../modules/azurerm_key_vault"
#   key_vaults = var.key_vaults
# }


module "nsg" {
  depends_on = [module.rg]
  source     = "../../modules/network_security_group"
  nsg        = var.nsgs 
}


module "nsg-nic-association" {
  depends_on = [module.nsg, module.vms]
  source     = "../../modules/nsg_nic_association"
  nsg_nic_associations = var.nsg_nic_associations  
}

module "sql_server" {
  depends_on = [module.rg]
  source     = "../../modules/azure_sql_server"
  mssql_servers = var.mssql_servers 
}

module "sql_database" {
  depends_on = [ module.rg , module.sql_server ]
source = "../../modules/azurerm_sql_database"
mssql_database = var.mssql_database
}