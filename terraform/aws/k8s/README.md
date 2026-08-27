# Minimal EKS Terraform configuration

This configuration creates a VPC, three public subnets across availability zones, an EKS cluster, and a managed node group.

## Run it

Provide AWS credentials with permission to create VPC, EC2, IAM, and EKS resources. Create `terraform.tfvars` with your public IPv4 address:

```hcl
region          = "eu-central-1"
cluster_name    = "jcasc-eks"
api_access_cidr = "203.0.113.10/32"
```

Replace `203.0.113.10/32` with your public IPv4 address followed by `/32`. This is the only public address permitted to access the Kubernetes API.

Then run:

```sh
terraform init
terraform plan
terraform apply
```

After apply:

```sh
aws eks update-kubeconfig --region eu-central-1 --name jcasc-eks
kubectl get nodes
```

The worker nodes are in public subnets to keep this example small. For production, use private node subnets with NAT gateways. Run `terraform destroy` when the environment is no longer needed.
