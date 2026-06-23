---
title: MASO (Multi-Agent)
description: "Multi-Agent Security Operations (MASO): risk-proportionate runtime controls for systems where many AI agents collaborate. The same four layers, now governing what agents do to each other."
template: redesign.html
nav_active: framework
---

<section class="airs-section airs-hero airs-hero--narrow airs-section--paper airs-section--first">
  <div class="airs-wrap">
    <p class="airs-eyebrow airs-eyebrow--accent airs-hero__eyebrow">MASO &middot; Multi-agent security</p>
    <h1 class="airs-hero__title">When agents work together, trust gets <em class="is-accent">complicated.</em></h1>
    <p class="airs-hero__lead">Multi-Agent Security Operations secures systems where many AI agents collaborate. The same four layers apply &mdash; but now they have to govern what agents do <strong>to each other</strong>.</p>
    <div class="airs-btns">
      <a class="airs-btn airs-btn--primary" href="/maso/demo/">Try the interactive demo &rarr;</a>
      <a class="airs-btn airs-btn--secondary" href="/maso/reference/">Read the full reference</a>
    </div>
  </div>
</section>

<section class="airs-section airs-section--card airs-center">
  <div class="airs-wrap--narrow">
    <figure class="airs-figure">
      <img class="arch-diagram airs-figure__img" src="/images/maso-hero.svg" alt="One chatbot guarded by a single security boundary, versus a fleet of agents each handing work to the next, secured as a system">
      <figcaption class="airs-figure__cap">Securing one chatbot is securing one boundary. Securing a fleet means securing every hand-off between agents.</figcaption>
    </figure>
  </div>
</section>

<section class="airs-section airs-section--paper">
  <div class="airs-wrap">
    <p class="airs-eyebrow">The shift</p>
    <h2 class="airs-h2">One chatbot is one risk. A fleet is a system of risks.</h2>
    <p class="airs-intro">Every agent is fragile in the same ways. Put them in a line and the failures don't add up &mdash; they multiply.</p>
    <div class="airs-cards">
      <div class="airs-card">
        <p class="airs-card__label">Injection propagates</p>
        <p class="airs-card__body">A poisoned document one agent reads becomes an instruction the next agent obeys. One foothold spreads down the chain.</p>
      </div>
      <div class="airs-card">
        <p class="airs-card__label">Errors compound</p>
        <p class="airs-card__body">One agent's hallucination becomes another's "fact". Mistakes are repeated with confidence instead of caught.</p>
      </div>
      <div class="airs-card">
        <p class="airs-card__label">Privilege goes transitive</p>
        <p class="airs-card__body">If agent A delegates to agent B, and B can touch a tool, then A effectively can too. Authority leaks through hand-offs.</p>
      </div>
    </div>
  </div>
</section>

<section class="airs-section airs-section--card airs-center">
  <div class="airs-wrap--narrow">
    <p class="airs-eyebrow">The core idea</p>
    <p class="airs-statement">Agents can't police themselves. Something outside the agent has to <em>declare what it should do, constrain what it can do, and judge whether it did the right thing</em> &mdash; before an irreversible action is committed.</p>
    <a class="airs-textlink" href="/constraining-agents/">Why agents need external evaluation &rarr;</a>
  </div>
</section>

<section class="airs-section airs-section--paper">
  <div class="airs-wrap">
    <p class="airs-eyebrow">How it's organised</p>
    <h2 class="airs-h2">Pick what your deployment needs. Deselect the rest.</h2>
    <p class="airs-intro">MASO is a system, not a checklist: declarations of intent, controls that enforce them, tiers that scale the scrutiny, and PACE for when something breaks.</p>
    <div class="airs-cards airs-cards--roles">
      <a class="airs-card" href="/maso/controls/objective-intent/">
        <p class="airs-card__title">Declared intent</p>
        <p class="airs-card__body">Every agent, judge, and workflow runs against a versioned Objective Intent Spec &mdash; the statute book the judge rules against.</p>
        <span class="airs-card__more">Objective Intent &amp; mandates &rarr;</span>
      </a>
      <a class="airs-card" href="/maso/reference/#control-domains">
        <p class="airs-card__title">Eleven control domains</p>
        <p class="airs-card__body">Identity, data, execution, observability, supply chain, epistemic integrity, privileged agents, and more &mdash; scaled by tier.</p>
        <span class="airs-card__more">Browse the control domains &rarr;</span>
      </a>
      <a class="airs-card" href="/maso/implementation/tier-1-supervised/">
        <p class="airs-card__title">Three tiers</p>
        <p class="airs-card__body">Supervised, managed, autonomous. Scrutiny scales to autonomy: approve every write, or auto-approve the low-risk ones.</p>
        <span class="airs-card__more">Start at Tier 1 &rarr;</span>
      </a>
      <a class="airs-card" href="/pace-resilience/">
        <p class="airs-card__title">PACE resilience</p>
        <p class="airs-card__body">Primary, Alternate, Contingency, Emergency. Every layer has a defined failure mode and a safe state to fall back to.</p>
        <span class="airs-card__more">How MASO fails safe &rarr;</span>
      </a>
      <a class="airs-card" href="/maso/threat-intelligence/incident-tracker/">
        <p class="airs-card__title">Threat intelligence</p>
        <p class="airs-card__body">Real incidents and a red-team playbook ground every control in attacks that have actually happened.</p>
        <span class="airs-card__more">See the incidents &rarr;</span>
      </a>
      <a class="airs-card" href="/maso/distributed-architecture/">
        <p class="airs-card__title">Distributed architecture</p>
        <p class="airs-card__body">At scale, Layer 2 becomes sidecars, a hardened message bus, and agent-to-agent IAM &mdash; not one judge as a chokepoint.</p>
        <span class="airs-card__more">Scale beyond a single judge &rarr;</span>
      </a>
    </div>
  </div>
</section>

<section class="airs-section airs-section--card airs-center">
  <div class="airs-wrap">
    <p class="airs-eyebrow">Visual navigation</p>
    <h2 class="airs-h2">The whole framework, on one map.</h2>
    <figure class="airs-figure">
      <img class="arch-diagram airs-figure__img" src="/images/maso-tube-map.svg" alt="MASO tube map: coloured lines for control domains, stations for key controls, zones for implementation tiers, and the PACE river running through the centre">
      <figcaption class="airs-figure__cap">Lines are control domains, stations are key controls, zones are tiers, and the PACE river runs through the middle.</figcaption>
    </figure>
  </div>
</section>

<section class="airs-section airs-section--ink airs-center">
  <div class="airs-wrap--narrow">
    <p class="airs-eyebrow">Go deeper</p>
    <h2 class="airs-cta__title">Ready for the full picture?</h2>
    <p class="airs-cta__body">The reference has every control domain, the OWASP mappings, the tiers, the cost numbers, and the honest trade-offs.</p>
    <div class="airs-btns">
      <a class="airs-btn airs-btn--primary" href="/maso/reference/">Read the full reference &rarr;</a>
      <a class="airs-btn airs-btn--secondary" href="https://airuntimesecurity.co.za">Learn MASO step by step</a>
    </div>
  </div>
</section>
