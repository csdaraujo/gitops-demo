module "demo-api" {
  source = "../demo-api"

  acr = {
    name                = "acrgitopsdemo"
    resource_group_name = "rg-shared-gitops-demo"
  }

  env = "dev"
}
