
resource "aws_instance" "server" {
  count = var.run_remote_script ? 1 : 0
  ami           = "ami-06ca3ca175f37dd66"
  instance_type = "t2.micro"

  associate_public_ip_address = true

provisioner "remote-exec" {
  inline = [
    "bash scripts/setup.sh ${var.remote_domain}"
  ]
}

  #iam_instance_profile = "tf-testing-role"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.priv_key)
    host        = self.public_ip
    agent       = false
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
