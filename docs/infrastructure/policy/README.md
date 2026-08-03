---
title: Policy as Code - OPA and Kyverno
description: "Runnable Open Policy Agent (Rego) and Kyverno starter policies that enforce infrastructure controls: agent egress restrictions, tool permission boundaries, token scoping, and sandbox isolation."
---

# Policy as Code: OPA and Kyverno

The framework says *what* to enforce. These templates are a running start on *how*, as code you can drop into an admission controller or an authorization gateway rather than writing from scratch. Each policy names the [infrastructure controls](../reference.md) it enforces and the [runtime layer](../handoff-matrix.md) it belongs to.

!!! warning "Starting points, not drop-in production policy"
    These are deliberately small and readable. Load allowlists, manifests, and destinations from your own configuration, wire them to your real identities, and test them against your traffic before enforcing. Treat them as the first commit, not the last.

## Open Policy Agent (Rego)

[OPA](https://www.openpolicyagent.org/) evaluates these at an authorization point: an API gateway, an egress proxy, or a tool-call broker. All three use `import rego.v1` (OPA 1.0+).

<div class="grid cards" markdown>

-   **agent_egress.rego** &middot; NET-04, NET-01

    ---

    Default-deny egress allowlist per agent identity, with a hard denylist for metadata endpoints (SSRF).

    [:octicons-download-24: Download](opa/agent_egress.rego)

-   **tool_permission_boundary.rego** &middot; TOOL-01/02/03, DEL-01

    ---

    Enforce the tool manifest at the gateway, constrain parameters to declared bounds, and block delegated privilege escalation.

    [:octicons-download-24: Download](opa/tool_permission_boundary.rego)

-   **token_scope.rego** &middot; SEC-02, IAM-06, DEL-05

    ---

    Reject tokens that are long-lived, wildcard-scoped, unbound to the session, or missing principal propagation.

    [:octicons-download-24: Download](opa/token_scope.rego)

</div>

### Example: agent egress

The egress policy denies by default and only permits a destination that is on the requesting agent's allowlist, unless the host is on the global denylist:

```rego
package airs.egress

import rego.v1

default allow := false

allow if {
	not denied
	some host in allowlist[input.agent]
	host == input.destination.host
}

denied if input.destination.host in denylist
```

Evaluate a request:

```bash
# input.json: {"agent":"research-agent","destination":{"host":"api.search-provider.example.com"}}
opa eval -d agent_egress.rego -i input.json 'data.airs.egress.decision'
```

The `decision` object returns `allow` plus a `reason`, so the gateway can write the enforcement outcome straight into the [agent chain log](../controls/logging-and-observability.md) (LOG-04).

### Example: tool permission boundary

`tool_permission_boundary.rego` permits a tool call only when the tool is in the agent's manifest, every parameter is within its declared bound (`enum`, `number` range, or `string` pattern), and, for a delegated call, the tool is also present in the delegating agent's grant. That last check is how DEL-01 (no privilege escalation through delegation) becomes executable.

## Kyverno

[Kyverno](https://kyverno.io/) runs as a Kubernetes admission controller. These `ClusterPolicy` resources harden the pods that run agent workloads.

<div class="grid cards" markdown>

-   **require-agent-sandbox-isolation.yaml** &middot; SAND-01/04/05, SESS-02

    ---

    Block admission of any `agent-sandbox` pod that shares host namespaces, allows privilege escalation, keeps capabilities, has a writable root filesystem, lacks a hardened runtime class, or omits CPU/memory limits.

    [:octicons-download-24: Download](kyverno/require-agent-sandbox-isolation.yaml)

-   **restrict-agent-egress.yaml** &middot; NET-01/02/04

    ---

    Require agent namespaces to be egress-controlled and generate a default-deny-egress `NetworkPolicy` (DNS only) so egress must be opened explicitly per destination.

    [:octicons-download-24: Download](kyverno/restrict-agent-egress.yaml)

</div>

```bash
# Apply and confirm the policies are ready.
kubectl apply -f require-agent-sandbox-isolation.yaml -f restrict-agent-egress.yaml
kubectl get clusterpolicy
```

A pod that opts into sandbox enforcement carries the label the policies match on:

```yaml
metadata:
  labels:
    airs.io/workload: agent-sandbox
```

## Control coverage

| Policy | Controls | Runtime layer |
|--------|----------|---------------|
| `agent_egress.rego` | NET-04, NET-01 | [Layer 01](../handoff-matrix.md) |
| `tool_permission_boundary.rego` | TOOL-01, TOOL-02, TOOL-03, DEL-01 | [Layer 01](../handoff-matrix.md) |
| `token_scope.rego` | SEC-02, IAM-06, DEL-05 | [Layer 01](../handoff-matrix.md) |
| `require-agent-sandbox-isolation.yaml` | SAND-01, SAND-04, SAND-05, SESS-02 | [Layer 01](../handoff-matrix.md) + [Circuit Breaker](../../glossary.md) |
| `restrict-agent-egress.yaml` | NET-01, NET-02, NET-04 | [Layer 01](../handoff-matrix.md) |

These control IDs resolve in the [machine-readable catalog](../catalog/README.md); filter the catalog on the same IDs to check which controls still need a policy.

!!! info "References"
    - [Open Policy Agent documentation](https://www.openpolicyagent.org/docs/latest/)
    - [Kyverno documentation](https://kyverno.io/docs/)
    - [Infrastructure Controls Reference](../reference.md)
    - [Machine-Readable Control Catalog](../catalog/README.md)
    - [Control Handoff Matrix](../handoff-matrix.md)
