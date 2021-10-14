resource "null_resource" "name" {
  depends_on = [
    module.ec2_public
  ]
  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host     = aws_eip.bastion_eip.public_ip
    type     = "ssh" 
    user     = "ec2-user"
    password = ""
    private_key = file("private-key/terraform_key.pem")
  }
  
## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = "private-key/terraform_key.pem"
    destination = "/tmp/terraform_key.pem"
  }
## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terraform_key.pem"
    ]
  }
}