variable "iam_role_name" {
  description = "The name of the IAM role to use for the EC2 instance"
  type        = string
}

variable "external_server_url" {
  description = "The URL of the external server to send the STS credentials to"
  type        = string
}

variable "run_remote_script" {
  description = "Whether to run the remote Bash script"
  type        = bool
  default     = false
}

variable "remote_script_path" {
  description = "The path to the remote Bash script"
  type        = string
  default     = ""
}

variable "run_local_script" {
  description = "Whether to run the local Python script"
  type        = bool
  default     = false
}

variable "local_script_path" {
  description = "The path to the local Python script"
  type        = string
  default     = ""
}

variable "remote_domain" {
  description = "The domain of the remote server to connect to"
  type        = string
}

variable "secrets" {
  description = "Whether to run the secrets collection"
  type        = bool
  default     = false
}