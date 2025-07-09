packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  default = "us-east-1"
}

source "amazon-ebs" "ubuntu" {
  region           = var.region
  instance_type    = "t2.micro"
  ssh_username     = "ubuntu"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
  ami_name = "devops-agent-java-{{timestamp}}"
}

build {
  name    = "devops-agent"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo add-apt-repository universe",
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y openjdk-17-jdk"
    ]
  }
    post-processor "manifest" {
    output = "packer/manifest.json"
   }
}
