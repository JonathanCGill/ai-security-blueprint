---
title: Implement
description: "Implement MASO: Objective Intent, eleven control domains, three tiers, and integration guides for LangGraph, AutoGen, CrewAI, and Bedrock."
search:
  boost: 3
---

# Implement

Objective Intent, 11 control domains, three tiers, and integration guides for LangGraph, AutoGen, CrewAI, and Bedrock. Pick what your deployment needs; consciously deselect the rest.

<div class="grid cards" markdown>

-   :material-target:{ .lg .middle } **Objective Intent**

    ---

    What the system is allowed to be trying to do. Start here; every control below inherits from it.

    [:octicons-arrow-right-24: Read Objective Intent](../controls/objective-intent.md)

-   :material-shield-lock:{ .lg .middle } **The 11 control domains**

    ---

    Identity, permissions, epistemic integrity, data protection, execution, observability, supply chain, and the rest, scaled by tier.

    [:octicons-arrow-right-24: Browse the domains](../controls/index.md)

-   :material-cube-outline:{ .lg .middle } **Environment Containment**

    ---

    The blast radius: what an agent can reach when it misbehaves, and how to make that set small.

    [:octicons-arrow-right-24: Contain the environment](../environment-containment.md)

-   :material-stairs:{ .lg .middle } **The three tiers**

    ---

    Supervised, managed, autonomous. Scrutiny scales to autonomy. Start at Tier 1 and graduate.

    [:octicons-arrow-right-24: Start at Tier 1](../implementation/tier-1-supervised.md)

-   :material-connection:{ .lg .middle } **Integration Guide**

    ---

    Wire the controls into your framework: LangGraph, AutoGen, CrewAI, Bedrock, and the patterns that carry across all of them.

    [:octicons-arrow-right-24: Wire it in](../integration/integration-guide.md)

</div>

!!! info "Where next"
    Built the controls? Move to [Operate](../operate/index.md) to see how MASO runs, degrades, and fails safe, or to [Evidence](../evidence/index.md) to see the tiers running under load.

---

*Implementing on a single system first? The same controls, one boundary, are in [ASO](../../aso/index.md).*
