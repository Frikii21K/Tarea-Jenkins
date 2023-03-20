terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.6.0"
    }
  }
}

provider "digitalocean" {
  token = "dop_v1_91fe462dda5361db76f9dcd3d97b99d836792c6481b9c1916f92d92f3c1fef04"
}

data "digitalocean_ssh_key" "anyery" {
  name= "anyery"
  #public_key = file("~/.ssh/id_rsa.pub")
}


resource "digitalocean_droplet" "anyery" {
  image  = "ubuntu-20-04-x64"
  name   = "TerraJenkins"
  region = "nyc1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.anyery.id
  ]
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
    host     = self.ipv4_address
  }


provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y git",
      "apt-get update",
      "snap install docker          # version 20.10.17",
      "git clone https://github.com/Frikii21K/Tarea-Jenkins.git",
      "cd Tarea-Jenkins",
      "docker-compose up"
    ]
  }

}
