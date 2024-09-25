# terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | 4.67.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                  | Type     |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_eip.reviews_server_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)                                                         | resource |
| [aws_instance.reviews_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                                   | resource |
| [aws_lb.reviews_server_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)                                                            | resource |
| [aws_lb_listener.reviews_server_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener)                                 | resource |
| [aws_lb_listener.reviews_server_lb_listener_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener)                           | resource |
| [aws_lb_target_group.reviews_server_lb_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)                               | resource |
| [aws_lb_target_group_attachment.reviews_server_tg_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_route53_record.reviews_server_lb_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                                | resource |
| [aws_route53_record.root_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                                          | resource |
| [aws_security_group.bitbucket_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                         | resource |
| [aws_security_group.reviews_server_lb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                 | resource |
| [aws_security_group.reviews_server_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                    | resource |
| [aws_security_group.reviews_server_world_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                              | resource |

## Inputs

| Name                                                                                          | Description                                                 | Type           | Default | Required |
| --------------------------------------------------------------------------------------------- | ----------------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_alb_name"></a> [alb_name](#input_alb_name)                                     | The name of the application load balancer                   | `string`       | n/a     |   yes    |
| <a name="input_ami_id"></a> [ami_id](#input_ami_id)                                           | The AMI ID to use for the instance                          | `string`       | n/a     |   yes    |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region)                               | The AWS region to create resources in                       | `string`       | n/a     |   yes    |
| <a name="input_bitbucket_ips"></a> [bitbucket_ips](#input_bitbucket_ips)                      | The CIDR blocks for Bitbucket IPs                           | `list(string)` | n/a     |   yes    |
| <a name="input_certificate_arn"></a> [certificate_arn](#input_certificate_arn)                | The ARN of the ACM certificate                              | `string`       | n/a     |   yes    |
| <a name="input_ebs_encrypted"></a> [ebs_encrypted](#input_ebs_encrypted)                      | Whether or not to encrypt the EBS volume                    | `bool`         | n/a     |   yes    |
| <a name="input_ebs_volume_size"></a> [ebs_volume_size](#input_ebs_volume_size)                | The size of the EBS volume, in GiB                          | `number`       | n/a     |   yes    |
| <a name="input_hosted_zone_id"></a> [hosted_zone_id](#input_hosted_zone_id)                   | Route 53 hosted zone                                        | `string`       | n/a     |   yes    |
| <a name="input_hosted_zone_name"></a> [hosted_zone_name](#input_hosted_zone_name)             | Route 53 hosted zone name                                   | `string`       | n/a     |   yes    |
| <a name="input_iam_instance_profile"></a> [iam_instance_profile](#input_iam_instance_profile) | The IAM instance profile to associate with the EC2 instance | `string`       | n/a     |   yes    |
| <a name="input_instance_name"></a> [instance_name](#input_instance_name)                      | The name to use for the instance                            | `string`       | n/a     |   yes    |
| <a name="input_instance_type"></a> [instance_type](#input_instance_type)                      | The instance type for the EC2 instance                      | `string`       | n/a     |   yes    |
| <a name="input_key_name"></a> [key_name](#input_key_name)                                     | The key pair name to use for the instance                   | `string`       | n/a     |   yes    |
| <a name="input_my_ip_cidr"></a> [my_ip_cidr](#input_my_ip_cidr)                               | Your IP address in CIDR format                              | `string`       | n/a     |   yes    |
| <a name="input_subnets"></a> [subnets](#input_subnets)                                        | List of subnet ids for the load balancer                    | `list(string)` | n/a     |   yes    |
| <a name="input_target_group_name"></a> [target_group_name](#input_target_group_name)          | The name of the target group                                | `string`       | n/a     |   yes    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                           | The ID of the VPC for the target group                      | `string`       | n/a     |   yes    |
| <a name="input_world_security_group"></a> [world_security_group](#input_world_security_group) | Security group for world                                    | `string`       | n/a     |   yes    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
