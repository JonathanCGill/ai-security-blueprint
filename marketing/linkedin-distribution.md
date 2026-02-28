# LinkedIn Distribution Content

## The Post (Feed Text)

> I've spent 20+ years securing enterprise systems. Every one of them had a property AI doesn't: determinism.
>
> Same input, same output. You test it, you prove it, you ship it.
>
> AI breaks that contract. Same prompt, different answer. By design. Which means your pre-deployment security model — no matter how thorough — proves the system *can* behave correctly. Not that it *will*.
>
> So I built a practitioner's reference. Not a product. Not a vendor pitch. A practical reference for applying security principles we already trust — defence in depth, least privilege, separation of duties, fail-safe defaults — to systems that don't behave like anything we've secured before. Take what's useful, adapt it, ignore what doesn't fit.
>
> The article below walks through the thinking. Where the old principles still hold. Where they break. And what to do about the gap.
>
> If you're a CISO trying to write an AI security strategy, an architect working out where the controls go, or an engineer wondering why your guardrails aren't enough — this is for you.
>
> [Link to article]
>
> #AISecurity #Cybersecurity #EnterpriseAI #CISO #SecurityArchitecture

---

## The Article

---

# You Already Know How to Secure AI. You Just Don't Know It Yet.

**The security principles are the same. The implementation has to change. Here's the thinking.**

---

I've worked in enterprise security for over two decades. Networks, applications, cloud, identity, incident response — the usual tour of duty. Through all of it, one contract held: systems are deterministic. Same input, same output. You test them, you prove they work, you deploy them, you protect them.

AI breaks that contract.

And when I realised *how* it breaks it, I started building a practical reference. Not a product. Not a compliance checklist. A practitioner's reference for applying security principles we already trust to systems that don't behave like anything we've secured before. Take what's useful, adapt it, ignore what doesn't fit.

This article is about that thinking. Where the old principles hold. Where they fracture. And what fills the gap.

---

## The principles haven't changed

Defence in depth. Least privilege. Separation of duties. Fail-safe defaults. These aren't going anywhere. They've survived every technology shift for decades because they describe *how systems fail*, not how specific technologies work.

AI systems fail the same way everything else fails — through excessive trust, missing controls, unmonitored behaviour, and assumptions that hold right up until they don't.

So the starting point isn't "AI needs new security thinking." The starting point is: **the thinking we already have is remarkably good. We just need to apply it to a system with different properties.**

---

## The property that changes everything

Traditional software is deterministic. Run the same function with the same input and you get the same output. You can test it exhaustively. You can prove correctness. Your security model assumes the system behaves as designed, and your controls protect it from external threats.

AI is non-deterministic. Same prompt, same model, same parameters — different response. Not occasionally. By design. The non-determinism is the value. It's why AI can handle novel inputs, interpret ambiguity, and generate creative outputs.

It's also why your test suite proves the system *can* behave correctly, but cannot prove it *will* behave correctly on the next request.

This single property — non-determinism — cascades through every assumption in your security model:

**Testing changes.** You can't test exhaustively because the input space is natural language — effectively infinite. Your test suite is a sample, not a proof.

**Trust changes.** You can't trust the output the way you trust a function return. The model might hallucinate, drift, follow an injected instruction, or generate something technically correct but contextually dangerous.

**Monitoring changes.** You can't just watch for known-bad. You need to detect unknown-bad — outputs that don't match any signature but aren't appropriate for the context. That requires semantic understanding, not pattern matching.

**Failure changes.** Systems don't fail in the ways you anticipated. They fail in ways that look like normal operation — a fluent, confident, wrong answer that passes every traditional check.

This is not theoretical. This is the operating reality for every enterprise deploying AI today.

---

## Defence in depth, reapplied

Defence in depth says: no single control is sufficient. Layer your defences so that when one fails, another catches it.

For traditional systems, that looks like firewalls, WAFs, authentication, authorisation, input validation, logging, and incident response. Each layer independent. Each catching different failure modes.

For AI, the same principle applies — but the layers must address different categories of failure:

**Known-bad.** Patterns you can define in advance — PII in outputs, injection signatures in inputs, content policy violations. These need fast, synchronous blocking. Real-time. Sub-10ms. This is your first layer.

**Unknown-bad.** Failures you couldn't enumerate — novel injection techniques, contextually inappropriate responses, subtle hallucinations, scope violations that don't match any pattern. These need semantic evaluation. An independent model assessing whether the primary model's output is appropriate. Slower, deeper, asynchronous. This is your second layer.

**Ambiguous.** Cases where automated systems genuinely cannot determine correctness — cultural nuance, business context that requires human judgement, edge cases where the right answer depends on information the system doesn't have. These need human oversight, scoped to the risk. This is your third layer.

Three layers. Three failure categories. Each independent, each catching what the others miss.

This isn't novel architecture. It's defence in depth, applied to non-deterministic outputs. The principle is the same. The implementation changes because the threat surface is different.

---

## Least privilege, rethought

Least privilege says: grant only the minimum access required for the task.

For a database user, that's straightforward — restrict tables, columns, operations. For an AI agent that interacts in natural language, takes actions through tool calls, and operates across systems? Least privilege means something more layered:

**What can it access?** Scope the data. Not "the agent can read the database" — which tables, which rows, which columns. If the agent doesn't need customer financials to answer a product question, it shouldn't see them. Full stop.

**What can it do?** Scope the actions. Define an explicit allowlist. Not "the agent can use tools" — which tools, with what parameters, under what conditions. And enforce that at the infrastructure layer, not in the prompt.

**What can it spend?** Scope the resources. Hard caps on API calls, tokens, compute time, financial transactions. When the limit hits, execution stops. The agent doesn't get to decide.

**What can it delegate?** If you're running multi-agent systems, permissions don't transfer implicitly. Agent A having file access doesn't mean Agent B — which Agent A delegated to — inherits that access. Every agent has its own identity, its own scope, its own limits.

The principle is the same. The enforcement is different because you can't trust the agent to respect boundaries set in its instructions. You enforce them in infrastructure — network controls, API gateways, database views, resource quotas. The agent literally cannot exceed its privilege because the environment makes it impossible.

---

## Separation of duties, for AI

Separation of duties says: no single entity should control an entire process end-to-end.

In traditional systems, this means the person who writes a cheque isn't the person who approves it. In AI systems, it means something structurally similar but technically different:

**The model that generates the output is not the model that evaluates it.** If your primary model is compromised — through injection, drift, or adversarial manipulation — your evaluation layer must remain independent. Different model. Different provider if you can manage it. No shared context, no shared failure mode.

**The system that acts is not the system that monitors.** Your observability layer operates outside the AI pipeline. It watches everything — inputs, outputs, decisions, tool calls — and it has authority to halt the system. The AI cannot influence the monitor, and the monitor doesn't need the AI's cooperation.

**The agent that requests is not the agent that approves.** For high-impact actions, approval comes from a separate process. Not the same model reconsidering. Not a rubber-stamp re-check. An independent evaluation with different information, different criteria, and different authority.

This is the same principle enterprises have applied to financial controls for decades. We're just applying it to AI decision-making.

---

## Fail-safe defaults, for systems that fail differently

Fail-safe defaults say: when a system fails, it should fail to a secure state.

Traditional systems fail obviously. An error code. A crash. A timeout. You know something went wrong.

AI systems fail subtly. The output looks normal. It's fluent, confident, well-structured. But it's wrong — hallucinated data, followed an injected instruction, drifted from its intended scope. The system didn't crash. It failed while looking like it succeeded.

This means your fail-safe can't just handle crashes. It needs to handle the case where your safety controls themselves fail:

**If the first-layer filter goes down**, the system doesn't serve unfiltered AI responses. It activates a fallback — a deterministic response, a cached safe answer, or a graceful degradation that tells the user the system is temporarily limited.

**If the evaluation layer can't assess an output**, the output doesn't ship. Uncertainty is not permission to proceed. The default is hold, not release.

**If human reviewers are unavailable**, the system restricts scope to actions it can verify automatically. It doesn't expand autonomy to compensate for missing oversight.

The principle is: when in doubt, restrict. When a control degrades, tighten — don't loosen. And pre-decide these degradation paths before you need them. The middle of an incident is not the time to design your fallback.

---

## A thinking space, not a prescription

I built this framework as an open space for practitioners to think through these problems. It's MIT-licensed. There's no product behind it, no vendor pitch, no certification to sell.

It exists because I needed it. When I looked at the AI security landscape, I found two things:

**Standards that describe what should be true** — robust, trustworthy, safe, reliable — without specifying how to make it true in production.

**Products that solve specific problems** — guardrails for this, monitoring for that — without a coherent architecture that explains how the pieces fit together and what happens when they fail.

The gap was the thinking layer. The space where you work through: what security principles apply here? How do they translate? Where do they break? What do I need that I don't have yet?

That's what this framework is. Not a prescription — a thinking space. It maps the old principles to the new properties. It identifies where the principles still work and where you need new controls. It defines what "fail safely" means for a system that fails by looking like it succeeded.

If you're working on this problem — or about to start — it's open, it's free, and it's built for practitioners, not for slides.

---

## Where to start

If any of this resonates, here's how I'd think about next steps:

**If you're a security leader:** Start with the question "what AI is running in my estate right now?" Most organisations can't answer that cleanly. You can't secure what you can't see.

**If you're an architect:** Map your existing AI deployments to the three failure categories — known-bad, unknown-bad, ambiguous. Where are your gaps? Most organisations have the first layer. Almost nobody has the second.

**If you're an engineer:** Look at your AI system's failure mode. Not "what happens when the model returns an error" — what happens when the model returns a confident, wrong answer? If the answer is "nothing catches it," that's your starting point.

The framework is at [repository link]. Read it, challenge it, tell me where it's wrong. This thinking gets better with more practitioners in the room.

---

*Jonathan Gill — AI Runtime Behaviour Security, 2026*
