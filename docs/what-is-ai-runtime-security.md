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
    <p class="airs-hero__lead">It is the set of live controls that watch your AI <em>while it is working</em> &mdash; and step in the moment it does something it shouldn't.</p>
  </div>
</section>

<section class="airs-section airs-section--paper airs-article">
  <div class="airs-wrap--article">
    <p>Think of a new AI feature as a new employee. <strong>Governance</strong> is its job description and the company rulebook: what it is hired to do, what it must never do, and who is accountable when something goes wrong. Most organisations already have this part.</p>
    <p class="airs-muted">But a rulebook on its own never stopped anyone. <strong>Runtime security</strong> is the supervisor standing over their shoulder: checking the work in real time, catching mistakes before a customer ever sees them, and pulling the plug the moment something goes badly wrong.</p>

    <blockquote class="airs-pullquote">Governance decides what AI should do. Runtime security verifies what it actually does.</blockquote>

    <h2>Why does it matter now?</h2>
    <p class="airs-muted">For years, AI mostly answered questions. Now it acts: it books, buys, sends, edits, and reaches into other systems on your behalf. A wrong answer is awkward. A wrong action has consequences in the real world.</p>
    <p class="airs-muted">And almost every new failure traces back to a single trick: hidden instructions dressed up as ordinary content. A web page, a document, or an email the AI reads can quietly tell it to do something it was never meant to do. Catch that one move and most of the named threats lose their teeth.</p>

    <h2>How AIRS handles it</h2>
    <p class="airs-muted">AIRS answers it with four independent layers. Each does one job, and each keeps working even if the others fail.</p>
    <figure class="airs-figure">
      <img class="arch-diagram airs-figure__img" src="/images/three-layer-stack.svg" alt="Three stacked layers over an AI system: guardrails filter in real time, a model-as-judge reviews, and human oversight handles escalated decisions">
      <figcaption class="airs-figure__cap">Three layers sit over your AI system, each with its own speed and job. Circuit breakers stand behind them as the failsafe.</figcaption>
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
        <span class="airs-vlist__num">04</span>
        <div>
          <span class="airs-vlist__title">Circuit breakers</span>
          <p class="airs-vlist__summary">Stop everything and fail safe when needed.</p>
        </div>
      </div>
    </div>

    <div class="airs-actionrow">
      <a class="airs-btn airs-btn--primary" href="/architecture/">See the full framework &rarr;</a>
      <a class="airs-btn airs-btn--secondary" href="/#roles">Find your role</a>
    </div>
  </div>
</section>
