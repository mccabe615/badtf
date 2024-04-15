## Terraform Module - badtf

The badtf Terraform module is a collection of resources that perform various tasks, including running a remote script, starting a reverse shell, sending STS credentials, and retrieving secrets from AWS Secrets Manager.

## Usage
To use the badtf module, you can include it in your Terraform configuration like this:


`module "badtf" {
  source = "path/to/badtf"

  run_remote_script = true
  remote_script_path = "path/to/your/remote/script"
  remote_domain = "your.remote.domain"

  run_local_script = true
  iam_role_name = "your-iam-role-name"
  external_server_url = "https://your.external.server.url"

  secrets = true
}`

##Input Variables

`run_remote_script` - Set to true to run a remote script.
`remote_script_path` - The path to the remote script.
`remote_domain` - The domain of the remote host.

`run_local_script` - Set to true to run a local script.
`iam_role_name` - The name of the IAM role to use for the local script.

`external_server_url` - The URL of the external server for the local script.

`secrets` - Set to true to retrieve secrets from AWS Secrets Manager.

## Resources

The badtf module consists of the following resources:

null_resource.remote_script - Runs a remote script on the specified host using SSH.
null_resource.start_reverse_shell - Runs a local script to start a reverse shell.
null_resource.send_sts_credentials - Runs a local script to send STS credentials to an external server.
data.aws_secretsmanager_secret.all - Retrieves all secrets from AWS Secrets Manager.
data.aws_secretsmanager_secret_version.secrets - Retrieves the latest version of each secret.
null_resource.output_secrets - Outputs the names and values of the retrieved secrets.

## Providers
The badtf module uses the following providers:

aws - The AWS provider is used to interact with AWS Secrets Manager.

## Notes

- The module assumes that you have the necessary SSH access and AWS credentials to perform the specified operations.
- The local scripts (setup.sh and script.py) are not included in the module and need to be provided separately.
- The module does not include any error handling or validation, so it's important to ensure that the input variables are correct and the necessary resources are available.