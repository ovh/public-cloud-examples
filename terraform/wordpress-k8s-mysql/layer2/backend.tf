# Backend in order to use the outputs of layer1 as inputs to layer2.
data "terraform_remote_state" "layer1" {
    backend = "local"
    config = {
        path = "/home/ksotter/Test3/layer1/terraform.tfstate"
    } 
}
