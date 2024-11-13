module "minio-vpc" {
  source = "github.com/excircle/tf-aws-minio-vpc"

  application_name      = "minio-vpc"
  az_count              = 2
  make_private          = false
  createdby_tag         = "Terraform"
  owner_tag             = "AlexanderKalaj"
  purpose_tag           = "minio-vpc"
}


module "minio-cluster-1" {
  source = "./modules/tf-aws-minio-node"

  application_name          = "minio-clstr1-node"
  system_user               = "ubuntu"
  hosts                     = 4                              # Number of nodes with MinIO installed
  vpc_id                    = module.minio-vpc.vpc_id
  ebs_root_volume_size      = 10
  ebs_storage_volume_size   = 10
  make_private              = false
  ec2_instance_type         = "t2.medium"
  ec2_ami_image             = "ami-0b8c6b923777519db"        
  az_count                  = 2                              # Number of AZs to use
  subnets                   = module.minio-vpc.subnets
  num_disks                 = 4                              # Creates a number of disks
  sshkey                    = var.sshkey                     # Use env variables | export TF_VAR_sshkey=$(cat ~/.ssh/your-key-name.pub)
  ec2_key_name              = "quick-key"
  package_manager           = "apt"
  bastion_host              = false
}