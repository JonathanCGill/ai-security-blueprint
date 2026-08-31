# Control: NET-04 (control agent egress destinations), NET-01 (network zones)
# Layer: AIRS Layer 01 - Guardrails (deterministic prevention at the egress proxy)
#
# Enforce a default-deny egress allowlist for AI agents. Evaluate this at the
# egress proxy / API gateway that sits between the agent zone and the internet.
# Deny by default; an agent may only reach a host on its own allowlist.
#
# Test with: opa eval -d agent_egress.rego -i input.json 'data.airs.egress.decision'
package airs.egress

import rego.v1

# The set of destinations each agent identity is permitted to reach.
# In production, load this from the tool/egress manifest, not from the policy.
default allowlist := {
	"orchestrator": {"api.internal.example.com", "vault.internal.example.com"},
	"research-agent": {"api.search-provider.example.com"},
}

# Hosts no agent may ever reach, regardless of allowlist (metadata endpoints,
# link-local, and known exfiltration sinks). Deny wins over allow.
denylist := {
	"169.254.169.254", # cloud instance metadata (SSRF target)
	"metadata.google.internal",
}

default allow := false

allow if {
	not denied
	some host in allowlist[input.agent]
	host == input.destination.host
}

denied if input.destination.host in denylist

# Explain the decision so gateway logs (LOG-04) carry the reason.
decision := {
	"allow": allow,
	"agent": input.agent,
	"destination": input.destination.host,
	"reason": reason,
}

reason := "destination on denylist" if denied

reason := "destination on agent allowlist" if allow

reason := "destination not on agent allowlist (default deny)" if {
	not denied
	not allow
}
