package terraform

import rego.v1

deny contains msg if {
	some name, sg in input.resource.aws_security_group
	some rule in sg[_].ingress
	rule.from_port <= 22
	rule.to_port >= 22
	"0.0.0.0/0" in rule.cidr_blocks
	msg := sprintf("aws_security_group.%s: SSH (port 22) open to 0.0.0.0/0. Use SSM/a bastion or restrict the CIDR.", [name])
}

deny contains msg if {
	some name, acl in input.resource.aws_s3_bucket_acl
	acl[_].acl in {"public-read", "public-read-write"}
	msg := sprintf("aws_s3_bucket_acl.%s: a public ACL makes the bucket readable by anyone.", [name])
}

# Rule 3 (solution)
deny contains msg if {
	some name, db in input.resource.aws_db_instance
	db[_].publicly_accessible == true
	msg := sprintf("aws_db_instance.%s: database reachable from the Internet.", [name])
}

# Bonus: encryption at rest is mandatory
deny contains msg if {
	some name, db in input.resource.aws_db_instance
	some cfg in db
	not cfg.storage_encrypted == true
	msg := sprintf("aws_db_instance.%s: storage_encrypted must be true.", [name])
}
