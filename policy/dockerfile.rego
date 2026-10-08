package docker

import rego.v1

# Policy as code for Dockerfiles.
# Run: conftest test app/Dockerfile -p policy --namespace docker

# Rule (provided): the container must not run as root - there must be a USER instruction.
deny contains msg if {
	not has_user
	msg := "Dockerfile: missing USER instruction - the container will run as root."
}

has_user if {
	some instr in input
	instr.Cmd == "user"
}

# Rule (provided): do not store secrets in ENV (they get baked into the image layers).
deny contains msg if {
	some instr in input
	instr.Cmd == "env"
	regex.match(`(?i)(secret|password|token|key)`, instr.Value[0])
	msg := sprintf("Dockerfile: possible secret in ENV (%s). Inject it at runtime from a secret manager.", [instr.Value[0]])
}
