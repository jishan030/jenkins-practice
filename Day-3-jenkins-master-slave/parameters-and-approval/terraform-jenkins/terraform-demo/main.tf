terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "message" {
  type    = string
  default = "Hello from Terraform via Jenkins"
}

resource "local_file" "demo" {
  content  = var.message
  filename = "${path.module}/output/hello.txt"
}

output "file_path" {
  value = local_file.demo.filename
}
