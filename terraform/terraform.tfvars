location           = "Southeast Asia"
prefix             = "aksstore"
node_count         = 2
node_vm_size       = "Standard_B2s_v2"
kubernetes_version = "1.35"

tags = {
  environment = "demo"
  project     = "aks-store-demo"
  managed_by  = "terraform"
}
