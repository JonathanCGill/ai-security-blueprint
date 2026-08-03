# Control: SEC-02 (short-lived, scoped tokens), IAM-06 (session-scoped credentials),
#          DEL-05 (propagate user identity through chains)
# Layer: AIRS Layer 01 - Guardrails (validate the token before the call proceeds)
#
# Validate that a delegation / session token is short-lived, scoped to the task,
# and carries the originating user identity down the agent execution tree.
# Reject tokens that are long-lived, over-scoped, or missing principal
# propagation. This is the runtime counterpart to the pre-runtime requirement
# that credentials are session-scoped and never wildcard.
#
# input.token is the decoded claim set; input.now is the current unix time.
# input.required_scopes lists the scopes this specific call needs.
#
# Test with: opa eval -d token_scope.rego -i input.json 'data.airs.token.decision'
package airs.token

import rego.v1

# Maximum acceptable token lifetime, in seconds (15 minutes).
max_lifetime := 900

default valid := false

valid if {
	count(violations) == 0
}

violations contains "token expired" if {
	input.token.exp <= input.now
}

violations contains "token lifetime exceeds policy maximum" if {
	input.token.exp - input.token.iat > max_lifetime
}

violations contains "token grants wildcard scope" if {
	"*" in input.token.scopes
}

violations contains "token missing a required scope" if {
	some required in input.required_scopes
	not required in input.token.scopes
}

violations contains "token does not propagate an originating principal" if {
	not input.token.act.sub # RFC 8693 actor / delegation claim
}

violations contains "token not bound to the current session" if {
	input.token.sid != input.session_id
}

decision := {
	"valid": valid,
	"subject": input.token.sub,
	"violations": violations,
}
