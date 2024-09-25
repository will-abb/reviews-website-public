aws_region           = "us-east-1"
ami_id               = "ami-0f57aae39a1299807"
instance_type        = "t2.micro"
iam_instance_profile = "AmazonSSMRoleForInstancesQuickSetup"
key_name             = "personal-websites"
ebs_encrypted        = true
ebs_volume_size      = 30
instance_name        = "reviews-website"
my_ip_cidr           = "136.32.84.4/32"
hosted_zone_id       = "Z071426418GLVEH321Y7I"
hosted_zone_name     = "trendingtechdevices.com"
world_security_group = "world"
subnets              = ["subnet-08abef740b017c190", "subnet-032188003e1d4a81b", "subnet-04010a16be7414464"]
vpc_id               = "vpc-0806a23b71bed215a"
target_group_name    = "reviewsWebsite"
alb_name             = "reviewsWebsite"
certificate_arn      = "arn:aws:acm:us-east-1:005343251202:certificate/4858835f-59fa-4304-a3c8-61ee12b850b4"
bitbucket_ips = [
  "34.199.54.113/32",
  "34.232.25.90/32",
  "34.232.119.183/32",
  "34.236.25.177/32",
  "35.171.175.212/32",
  "52.54.90.98/32",
  "52.202.195.162/32",
  "52.203.14.55/32",
  "52.204.96.37/32",
  "34.218.156.209/32",
  "34.218.168.212/32",
  "52.41.219.63/32",
  "35.155.178.254/32",
  "35.160.177.10/32",
  "34.216.18.129/32",
  "3.216.235.48/32",
  "34.231.96.243/32",
  "44.199.3.254/32",
  "174.129.205.191/32",
  "44.199.127.226/32",
  "44.199.45.64/32",
  "3.221.151.112/32",
  "52.205.184.192/32",
  "52.72.137.240/32"
]
