variable "primary_region" {
  description = "Primary AWS region"
  default     = "ca-central-1"
}

variable "secondary_region" {
  description = "Secondary AWS region"
  default     = "us-east-1"
}

variable "ami_id_primary" {
  description = "Amazon Linux 2 AMI ID"
  default     = "ami-02cd5b9bfb2512340"  # Replace with a valid AMI for your region
}

variable "ami_id_secondary" {
  description = "Amazon Linux 2 AMI ID"
  default     = "ami-00a929b66ed6e0de6"  # Replace with a valid AMI for your region
}

variable "key_name_primary" {
  description = "Key pair name for the primary region"
  default     = "disaster_recovery"  # Or whatever you're using in ca-central-1
}

variable "key_name_secondary" {
  description = "Key pair name for the secondary region"
  default     = "Disaster_Recovery_2"
}