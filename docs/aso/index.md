---
title: ASO
description: "Agent Security Operations (ASO): AIRS applied to a single system. One model, one boundary, three layers and a circuit breaker. The foundation MASO extends to the fleet."
search:
  boost: 3
---

# ASO (Agent Security Operations)

**ASO (Agent Security Operations)** is AIRS applied to a single system: one model, one boundary, three layers and a circuit breaker. Everything [MASO](../maso/README.md) does between agents is this pattern, extended. If you run one AI system today, start here, you are also learning MASO.

Guardrails prevent. The judge detects. Humans decide. Breakers contain. On a single system those four wrap one input and one output. On a fleet, the same four extend into the space *between* agents. Learn them here, prove them here, then scale them.

<div class="grid cards" markdown>

-   :material-view-grid-outline:{ .lg .middle } **Architecture Overview**

    ---

    The three control layers and the circuit breaker, and how a single request passes through them.

    [:octicons-arrow-right-24: See the architecture](../architecture.md)

-   :material-shield-check:{ .lg .middle } **Core Controls**

    ---

    The single-agent implementation library: classify the risk, apply the layers, deselect what you don't need.

    [:octicons-arrow-right-24: Open the core controls](../core/reference.md)

-   :material-layers-triple-outline:{ .lg .middle } **Single-Agent Foundations**

    ---

    The whole single-agent architecture on one page, with pointers into the depth.

    [:octicons-arrow-right-24: Read the foundations](../foundations/README.md)

-   :material-lock-outline:{ .lg .middle } **Infrastructure Controls**

    ---

    The infrastructure layer underneath the model: identity, network, secrets, logging, and the platform patterns.

    [:octicons-arrow-right-24: Open the infrastructure library](../infrastructure/README.md)

-   :material-rocket-launch-outline:{ .lg .middle } **Fast Lane**

    ---

    The shortest safe path to production for a low-risk single-agent feature.

    [:octicons-arrow-right-24: Take the fast lane](../fast-lane.md)

</div>

## From one system to a fleet

The moment your single system starts handing work to another agent, you are running a fleet, and the boundaries multiply. Every ASO control has a MASO equivalent that extends it across the hand-off:

| ASO (one system) | Becomes, at fleet scale | In MASO |
|---|---|---|
| One identity, one set of permissions | Per-agent identity, least privilege across hand-offs | [Identity & Access](../maso/controls/identity-and-access.md) |
| Input guardrails on one prompt | Epistemic integrity between agents | [Prompt, Goal & Epistemic Integrity](../maso/controls/prompt-goal-and-epistemic-integrity.md) |
| One output check | Judging every hand-off | [Objective Intent](../maso/controls/objective-intent.md) |
| One circuit breaker | Kill-switch architecture for the fleet | [Environment Containment](../maso/environment-containment.md) |

!!! info "Where next"
    Running more than one agent already? Move to [MASO](../maso/README.md): the same layers, secured across every hand-off.
