# Set up a Backend in order to use the outputs of kube as inputs to layer2.
data "terraform_remote_state" "kube" {
    backend = "local"
    config = {
        path = "${path.cwd}/../01-kube/terraform.tfstate"
    } 
}
