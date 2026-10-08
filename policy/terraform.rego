package terraform

import rego.v1

# Policy as code for the Demo Shop Terraform.
# Run: conftest test infra/main.tf -p policy --namespace terraform

# Rule 1 (provided): no security group may open SSH (22) to the Internet.
deny contains msg if {
	some name, sg in input.resource.aws_security_group
	some rule in sg[_].ingress
	rule.from_port <= 22
	rule.to_port >= 22
	"0.0.0.0/0" in rule.cidr_blocks
	msg := sprintf("aws_security_group.%s: SSH (port 22) open to 0.0.0.0/0. Use SSM/a bastion or restrict the CIDR.", [name])
}

# Rule 2 (provided): no S3 bucket may be public.
deny contains msg if {
	some name, acl in input.resource.aws_s3_bucket_acl
	acl[_].acl in {"public-read", "public-read-write"}
	msg := sprintf("aws_s3_bucket_acl.%s: a public ACL makes the bucket readable by anyone.", [name])
}

# Rule 3 (EXERCISE): no RDS database may be publicly accessible.
# Hint: the resource is input.resource.aws_db_instance and the attribute is publicly_accessible.
# Follow the pattern of Rule 2. Write your rule here:

