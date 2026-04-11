variables {
  name                = "test"
  location            = "eastus"
  environment         = "test"
  resource_group_name = "rg-test"
}

run "create_vnet" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.this.name == "test-test-eastus"
    error_message = "VNet name not correctly formed"
  }
}