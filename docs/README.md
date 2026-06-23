---
title: AI Runtime Security (AIRS)
description: AI Governance decides what AI should do. AI Runtime Security verifies what it actually does. A vendor-neutral, risk-proportionate framework for running AI safely in production.
template: redesign.html
nav_active: home
---

<section class="airs-section airs-hero airs-section--paper airs-section--first">
  <div class="airs-wrap">
    <p class="airs-eyebrow airs-eyebrow--accent airs-hero__eyebrow">A framework for running AI safely</p>
    <h1 class="airs-hero__title">Governance decides what AI <em class="is-muted">should</em> do. Security verifies what it <em class="is-accent">actually</em> does.</h1>
    <p class="airs-lead">Most organisations have the first. Few have the second. That gap is where the failures live.</p>
    <div class="airs-btns">
      <a class="airs-btn airs-btn--primary" href="/what-is-ai-runtime-security/">Start here &rarr;</a>
      <a class="airs-btn airs-btn--secondary" href="/architecture/">See the framework</a>
    </div>
  </div>
</section>

<section class="airs-section airs-section--card">
  <div class="airs-wrap">
    <p class="airs-eyebrow">The gap</p>
    <h2 class="airs-h2">Two different jobs, often mistaken for one.</h2>
    <div class="airs-cards">
      <div class="airs-card">
        <p class="airs-card__label">Governance</p>
        <p class="airs-card__title">Asks: <em>what is this AI allowed to do?</em></p>
        <p class="airs-card__body">Policies, accountability, and audits set the intent. They decide the rules &mdash; but they cannot enforce them in the moment.</p>
      </div>
      <div class="airs-card airs-card--accent">
        <p class="airs-card__label airs-card__label--accent">Runtime security</p>
        <p class="airs-card__title">Asks: <em>is it doing that, right now?</em></p>
        <p class="airs-card__body">Live controls catch the prompt injection mid-request, check the output before users see it, and halt the agent that goes out of bounds.</p>
      </div>
    </div>
    <p class="airs-closingline">Your policy says the model must not leak data. Runtime security is what <em>actually stops it.</em></p>
  </div>
</section>

<section class="airs-section airs-section--paper" id="how">
  <div class="airs-wrap">
    <p class="airs-eyebrow">How it works</p>
    <h2 class="airs-h2">Four layers a request passes through.</h2>
    <p class="airs-intro">Each layer works on its own. If one fails, the others still hold. Start in detect-only, then turn on enforcement when you trust it.</p>
    <div class="airs-pipeline">
      <span class="airs-pill airs-pill--dashed">request</span>
      <span class="airs-pipeline__sep">&rsaquo;</span>
      <span class="airs-pill airs-pill--filled">guardrails</span>
      <span class="airs-pipeline__sep">&rsaquo;</span>
      <span class="airs-pill airs-pill--filled">reviewing</span>
      <span class="airs-pipeline__sep">&rsaquo;</span>
      <span class="airs-pill airs-pill--filled">oversight</span>
      <span class="airs-pipeline__sep">&rsaquo;</span>
      <span class="airs-pill airs-pill--filled">breakers</span>
      <span class="airs-pipeline__sep">&rsaquo;</span>
      <span class="airs-pill airs-pill--dashed">user</span>
    </div>
    <div class="airs-hairgrid airs-hairgrid--4">
      <div class="airs-layer">
        <p class="airs-layer__num">01</p>
        <p class="airs-layer__title">Guardrails</p>
        <p class="airs-layer__body">Fast, fixed boundaries that block the obvious failures at machine speed.</p>
      </div>
      <div class="airs-layer">
        <p class="airs-layer__num">02</p>
        <p class="airs-layer__title">Reviewing controls</p>
        <p class="airs-layer__body">A second look at the output before it reaches a user &mdash; catching the subtle failures guardrails miss.</p>
      </div>
      <div class="airs-layer">
        <p class="airs-layer__num">03</p>
        <p class="airs-layer__title">Human oversight</p>
        <p class="airs-layer__body">A person in the loop for high-stakes calls. The bigger the consequence, the closer the watch.</p>
      </div>
      <div class="airs-layer">
        <p class="airs-layer__num">04</p>
        <p class="airs-layer__title">Circuit breakers</p>
        <p class="airs-layer__body">The emergency stop. Halts the AI and switches to a safe fallback when something breaks.</p>
      </div>
    </div>
    <a class="airs-textlink" href="/architecture/">How the layers work together &rarr;</a>
  </div>
</section>

<section class="airs-section airs-section--card" id="roles">
  <div class="airs-wrap">
    <p class="airs-eyebrow">For your role</p>
    <h2 class="airs-h2">Where do you fit in?</h2>
    <p class="airs-intro">Three ways in. Each one starts where your job starts &mdash; and tells you what to do first.</p>
    <div class="airs-cards airs-cards--roles">
      <a class="airs-role" href="/what-is-ai-runtime-security/">
        <p class="airs-role__title">Set the strategy</p>
        <p class="airs-role__q">Is the board confident our AI controls actually work?</p>
        <p class="airs-role__roles">Security leaders &middot; Risk &amp; governance &middot; Compliance &middot; CIOs</p>
      </a>
      <a class="airs-role" href="/architecture/">
        <p class="airs-role__title">Design &amp; build</p>
        <p class="airs-role__q">Where do the controls go, and what do they cost?</p>
        <p class="airs-role__roles">Enterprise architects &middot; AI engineers</p>
      </a>
      <a class="airs-role" href="/what-is-ai-runtime-security/">
        <p class="airs-role__title">Own the product</p>
        <p class="airs-role__q">What do we need in place before we can ship?</p>
        <p class="airs-role__roles">Product owners &middot; Business owners &middot; Insider-threat teams</p>
      </a>
    </div>
  </div>
</section>

<section class="airs-section airs-section--paper airs-center">
  <div class="airs-wrap--narrow">
    <p class="airs-eyebrow">One idea underneath it all</p>
    <p class="airs-statement">Most AI attacks are the same event in disguise: <em>untrusted content treated as an instruction instead of as data.</em> Fix that one thing, and the long list of named threats collapses into a single problem you can actually hold.</p>
    <a class="airs-textlink" href="/what-is-ai-runtime-security/">Read the idea in full &rarr;</a>
  </div>
</section>

<section class="airs-section airs-section--ink airs-center">
  <div class="airs-wrap--narrow">
    <h2 class="airs-cta__title">Ship your first AI feature safely.</h2>
    <p class="airs-cta__body">Seven controls. One checklist. One decision on whether you need to go deeper.</p>
    <div class="airs-btns">
      <a class="airs-btn airs-btn--primary" href="/what-is-ai-runtime-security/">Start here &rarr;</a>
    </div>
  </div>
</section>
