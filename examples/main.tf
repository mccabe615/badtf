 provider "aws" {
    region = "us-east-1"
  }
  
module "resources" {

  source = "./modules/resources"

  run_remote_script  = true
  remote_script_path = "scripts/setup.sh"

  run_local_script  = true
  local_script_path = "scripts/setup.py"
}
