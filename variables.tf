variable "tenancy_ocid" {
  description = "Your OCI Tenancy OCID"
  type        = string
}

variable "user_ocid" {
  description = "Your OCI user OCID"
  type        = string
}

variable "rsa_private_key_path" {
  description = "Path to your RSA private key"
  type        = string
}

variable "fingerprint" {
  description = "Your OCI fingerprint"
  type        = string
}

variable "region_identifier" {
  description = "Your OCI Region ID"
  type        = string
}

variable "compute_shape" {
  description = "Compute Shape"
  type        = string
}
variable "instance_source_details_boot_volume_size_in_gbs" {
  description = "Compute instance boot volume size in GBs"
  type        = string
}

variable "memory_in_gbs" {
  description = "Compute instance memory size in GBs"
  type        = string
}

variable "ocpus" {
  description = "Compute instance processing unit count"
  type        = string
}

variable "image_id" {
  description = "Ubuntu 20.04 image ID found at https://docs.oracle.com/en-us/iaas/images/image/6013e506-ed35-4487-a3f7-122efbbbc6ad/"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key that you will use to connect to your instance"
  type        = string
}

variable "budget_amount" {
  description = "Target budget for account"
  type        = string
  default     = "1"
}

variable "alert_rule_recipients" {
  description = "Email address to be notified if budget is exceeded"
  type        = string
}
