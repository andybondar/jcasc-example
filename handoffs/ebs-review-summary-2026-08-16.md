# EBS Terraform Review Summary

**Prepared:** 2026-08-16 10:34:36 UTC

## Scope

We reviewed `../terraform/aws/modules/ebs` and the Terraform configuration related to it.

## Architecture confirmed

- `../terraform/aws/modules/ebs/common-variables.tf` is a symlink to `../terraform/aws/common/common-variables.tf`.
- That shared file declares `var.tags`, `var.region`, `var.tfstate_bucket`, and `var.az` (default `eu-central-1a`).
- Terraform loads the symlinked `.tf` file, so the EBS module's references to `var.tags` and `var.az` are valid.
- `../terraform/aws/modules/network/common-variables.tf` and `../terraform/aws/modules/ec2/common-variables.tf` point to that same shared file.
- `../terraform/aws/modules/network/main.tf` creates `aws_subnet.main` with `availability_zone = var.az`.
- The subnet's name comes from `var.subnet["name"]`; the intended configured name is `jcasc_subnet`.
- `../terraform/aws/modules/ec2/data.tf` looks up the subnet by `tag:Name = jcasc_subnet`.
- `../terraform/aws/modules/ebs/main.tf` creates its volume with `availability_zone = var.az`.

## Conclusions

- EBS and the EC2 instance's subnet are intentionally placed in the same Availability Zone through the shared `var.az`.
- Earlier concerns about undeclared `var.tags`/`var.az` and an Availability Zone mismatch were retracted after the shared symlinked configuration and related network resources were examined.
- No Terraform files were changed during the review.

## Potential remaining review items

- The EBS volume has a fixed `Name = "jcasc_home_disk"` tag.
- EC2 discovers the EBS volume by that tag with `most_recent = true`, rather than consuming an explicit volume ID/output.
- `disk_size` has no validation, such as requiring a positive value or documenting AWS's growth-only behavior.

## Volume discovery decision

- Using an EBS `volume_id` output with EC2 remote-state data was considered as an alternative to tag-based discovery.
- That approach requires the EC2 Terraform execution identity to have read access to the EBS Terraform state in S3 and creates a dependency on the EBS state backend and output contract.
- The decision is to retain tag-based discovery: this infrastructure is expected to have exactly one EBS volume with `Name = "jcasc_home_disk"`.
- No Terraform configuration was changed as part of this decision.

## Disk size validation decision

- The decision is to go without `disk_size` validation.
- No Terraform configuration was changed as part of this decision.