# LinkedIn Distribution — The MCP Problem

## Feed Post (Short)

> MCP is becoming the USB port for AI agents. Plug in a tool, the agent uses it. Simple. Powerful.
>
> Also completely unsecured by default.
>
> No authentication. No authorisation. No audit trail. Tool descriptions injected straight into the LLM's context — which is prompt injection by design.
>
> I wrote up the seven risks most teams aren't controlling, and what to do about each one. No vendor pitch. No product. Just the security architecture.
>
> If you're deploying AI agents with MCP tool access — or about to — this is the thinking you need before the incident report.
>
> [Link]
>
> #MCP #AISecurity #Cybersecurity #AIAgents #CISO #SecurityArchitecture

---

## Feed Post (Long — Article Preview)

> Every few years, a protocol appears that solves a real interoperability problem so well that adoption outpaces security.
>
> APIs got OAuth years after widespread deployment. Cloud got shared responsibility models after breaches forced the conversation. Containers got security tooling years after Docker went mainstream.
>
> MCP — the Model Context Protocol — is in that phase right now.
>
> It gives AI agents a universal way to discover and call tools. Databases, file systems, APIs, messaging platforms, code repositories. Plug in an MCP server, the agent can use it. The interoperability problem is solved.
>
> The security model? Still under construction.
>
> No native authentication. No authorisation framework. Tool descriptions that become prompt injection vectors. A consent model that degrades to rubber-stamping after the tenth approval popup. A supply chain of community-built servers with npm-scale trust assumptions.
>
> I've mapped the seven specific risks, matched them to existing security controls, and written up what teams should do now — before the incident timeline forces them to do it later.
>
> Open framework. MIT-licensed. No product. Built for practitioners.
>
> [Link]
>
> #MCP #ModelContextProtocol #AISecurity #Cybersecurity #AIAgents #CISO #EnterpriseAI

---

## Key Quotes for Engagement Posts

**Quote 1 — Tool poisoning hook:**
> "When an agent connects to an MCP server, tool descriptions are injected directly into the LLM's context. This is indirect prompt injection by design."

**Quote 2 — Consent fatigue:**
> "An agent working through a complex task might propose dozens of tool calls. Users approve the first few carefully, then start clicking 'Allow' reflexively. The human oversight layer degrades to zero effective control."

**Quote 3 — Supply chain:**
> "When you install an MCP server, you're granting an AI agent access to a capability through code you probably haven't audited. This is npm-scale supply chain risk applied to AI agent capabilities."

**Quote 4 — The pattern:**
> "MCP is in phase 2. The adoption is real. The security model is incomplete. The incidents haven't happened at scale yet — but the architecture makes them inevitable."

**Quote 5 — The fix:**
> "Put a gateway between the agent and the server. This single architectural decision addresses the majority of the risks. The agent proposes. The gateway decides."

---

## Suggested Posting Schedule

| Day | Content | Format |
|-----|---------|--------|
| Day 1 | Short feed post + article link | Text post |
| Day 3 | Quote 1 (tool poisoning) as standalone post with brief commentary | Text post |
| Day 5 | Quote 3 (supply chain) — "Raise your hand if you've audited every MCP server your agents use" | Text post |
| Day 7 | Quote 2 (consent fatigue) — ties to broader UX security pattern | Text post |
| Day 10 | Long feed post (for anyone who missed Day 1) | Article post |

---

## Hashtag Strategy

**Primary (always include):**
- #AISecurity
- #MCP

**Secondary (rotate):**
- #ModelContextProtocol
- #Cybersecurity
- #AIAgents
- #CISO
- #SecurityArchitecture
- #EnterpriseAI
- #AgenticAI
- #PromptInjection

---

*AI Runtime Behaviour Security, 2026 (Jonathan Gill).*
