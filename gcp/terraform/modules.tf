module "core" {
    source = "./core"
}

module "cluster" {
    source = "./cluster"
    vpc_name = module.core.vpc_name
    subnet_name = module.core.subnet1_name
}