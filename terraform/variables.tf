variable "location" {
  type        = string
  default     = "Southeast Asia"
}

variable "prefix" {
  type        = string
  default     = "aksstore"
}

variable "node_count" {
  type        = number
  default     = 2
}

variable "node_vm_size" {
  type        = string
  default     = "Standard_B2s_v2"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.35"
}

variable "tags" {
  type        = map(string)
  default = {
    environment = "dev"
    project     = "aks-store-demo"
    managed_by  = "terraform"
  }
}
