---
title: What is AI Runtime Security?
description: "AI Runtime Security (AIRS) is the discipline of reducing harm caused by AI systems during live operation. It provides risk-proportionate controls that organisations can select, adapt, or consciously deselect based on their own risk appetite and context."
template: redesign.html
nav_active: what-is
---

<section class="airs-section airs-hero airs-hero--narrow airs-section--paper airs-section--first">
  <div class="airs-wrap--narrow">
    <p class="airs-eyebrow airs-eyebrow--accent airs-hero__eyebrow">Start here</p>
    <h1 class="airs-hero__title">What is AI Runtime Security?</h1>
    <p class="airs-hero__lead">It is the set of live controls that watch what your AI does <em>while it is working</em>, the actions it takes, the tools it calls, the data and memory it reaches for, and step in the moment it crosses a line it shouldn't.</p>
  </div>
</section>

<section class="airs-section airs-section--paper airs-article">
  <div class="airs-wrap--article">
    <p>Think of a new AI feature as a new employee. <strong>Governance</strong> is its job description and the company rulebook: what it is hired to do, what it must never do, and who is accountable when something goes wrong. Most organisations already have this part.</p>
    <p class="airs-muted">But a rulebook on its own never stopped anyone. <strong>Runtime security</strong> is the supervisor standing over their shoulder: checking the work in real time, catching mistakes before a customer ever sees them, and pulling the plug the moment something goes badly wrong.</p>

    <blockquote class="airs-pullquote">Governance decides what AI should do. Runtime security verifies what it actually does.</blockquote>

    <h2>Why does it matter now?</h2>
    <p class="airs-muted">For years, AI mostly answered questions. Now it acts: it books, buys, sends, edits, and reaches into other systems on your behalf. A wrong answer is awkward. A wrong action has consequences in the real world.</p>
    <p class="airs-muted">And many of the most dangerous failures begin the same way: untrusted content, a tool, a stored memory, or borrowed authority quietly steering the AI while it runs. The classic version is a hidden instruction dressed up as ordinary content: a web page, a document, or an email the AI reads can tell it to do something it was never meant to do. Catch those moments and a long list of named threats loses much of its teeth.</p>
    <p class="airs-muted">So the surface worth watching is wider than the words going in and out. It includes who the AI is acting as and how far that authority reaches, what it remembers, the tools and models it trusts, and what it costs to run. The framework treats each of these as a place to put controls, not an afterthought. <a href="/architecture/#wider-boundary">See the wider boundary &rarr;</a></p>

    <h2>How AIRS handles it</h2>
    <p class="airs-muted">AIRS answers it with three independent control layers, and a circuit breaker behind them. Each does one job, and each keeps working even if the others fail.</p>
    <figure class="airs-figure">
      <img class="arch-diagram airs-figure__img" src="/images/three-layer-stack.svg" alt="Layers over an AI system: guardrails filter in real time, reviewing controls (scanners, a semantic firewall, and a model-as-judge) check the output, and human oversight handles escalated decisions">
      <figcaption class="airs-figure__cap">Three layers sit over your AI system. The reviewing layer is itself three independent checks. Circuit breakers stand behind them as the failsafe.</figcaption>
    </figure>
    <div class="airs-vlist">
      <div class="airs-vlist__row">
        <span class="airs-vlist__num">01</span>
        <div>
          <span class="airs-vlist__title">Guardrails</span>
          <p class="airs-vlist__summary">Block the obvious failures instantly.</p>
        </div>
      </div>
      <div class="airs-vlist__row">
        <span class="airs-vlist__num">02</span>
        <div>
          <span class="airs-vlist__title">Reviewing controls</span>
          <p class="airs-vlist__summary">Check the output before anyone sees it.</p>
        </div>
      </div>
      <div class="airs-vlist__row">
        <span class="airs-vlist__num">03</span>
        <div>
          <span class="airs-vlist__title">Human oversight</span>
          <p class="airs-vlist__summary">Put a person on the high-stakes calls.</p>
        </div>
      </div>
      <div class="airs-vlist__row">
        <span class="airs-vlist__num">Failsafe</span>
        <div>
          <span class="airs-vlist__title">Circuit breakers</span>
          <p class="airs-vlist__summary">Containment, not a behavioural layer: stop everything and fail safe when the three layers are bypassed or overwhelmed.</p>
        </div>
      </div>
    </div>

    <div class="airs-actionrow">
      <a class="airs-btn airs-btn--primary" href="/architecture/">See the full framework &rarr;</a>
      <a class="airs-btn airs-btn--secondary" href="/#roles">Find your role</a>
    </div>
  </div>
</section>
