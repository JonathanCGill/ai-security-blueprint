---
title: The Framework
description: "AIRS Framework architecture: risk-proportionate, layered runtime controls for single-agent and multi-agent AI systems."
template: redesign.html
nav_active: framework
---

<section class="airs-section airs-hero airs-hero--narrow airs-section--paper airs-section--first">
  <div class="airs-wrap">
    <p class="airs-eyebrow airs-eyebrow--accent airs-hero__eyebrow">The framework</p>
    <h1 class="airs-hero__title">Four layers, working together.</h1>
    <p class="airs-hero__lead">Four independent layers, each doing one job. If one fails, the others still hold. They start in <strong>detect-only</strong>, watching and logging without blocking, and graduate to <strong>enforcing</strong> once you trust what they catch.</p>
  </div>
</section>

<section class="airs-section airs-section--card airs-center">
  <div class="airs-wrap--narrow">
    <p class="airs-eyebrow">The pattern</p>
    <h2 class="airs-h2">Layered controls, end to end.</h2>
    <p class="airs-intro">A request passes through prevention, review, and human judgement on its way to the user. Each layer is independent, so a gap in one does not become a hole in all.</p>
    <figure class="airs-figure">
      <img class="arch-diagram airs-figure__img" src="/images/architecture-overview.svg" alt="AIRS reference architecture: input guardrails, the AI model, output guardrails, a reviewing layer, and human governance around them">
      <figcaption class="airs-figure__cap">Guardrails prevent, reviewing controls detect, humans decide. The same shape holds whether you run one model or many.</figcaption>
    </figure>
  </div>
</section>

<section class="airs-section airs-section--paper">
  <div class="airs-wrap">
    <div class="airs-layers">
      <div class="airs-layerrow">
        <div class="airs-layerrow__meta">
          <p class="airs-layerrow__num">Layer 01</p>
          <p class="airs-layerrow__latency">~10ms</p>
        </div>
        <div>
          <h2 class="airs-layerrow__title">Guardrails</h2>
          <p class="airs-layerrow__body">Fast, fixed boundaries: content policies, scope limits, tool permissions. These are the locked doors of the system: cheap, reliable, and impossible to talk your way past.</p>
          <a class="airs-textlink airs-textlink--sm" href="/core/controls/">How guardrails are built &rarr;</a>
        </div>
      </div>
      <div class="airs-layerrow">
        <div class="airs-layerrow__meta">
          <p class="airs-layerrow__num">Layer 02</p>
          <p class="airs-layerrow__latency">5ms&ndash;5s</p>
        </div>
        <div>
          <h2 class="airs-layerrow__title">Reviewing controls</h2>
          <p class="airs-layerrow__body">A second opinion before anything reaches the user: scanners, a semantic firewall, and a model-as-judge weighing the response against policy, context, and intent. This is what catches the subtle failures a fixed rule waves straight through. The judge is itself a model, so it is probabilistic and can be fooled: it informs the decision rather than making the final call, and it never stands in for the deterministic guardrails beneath it.</p>
          <a class="airs-textlink airs-textlink--sm" href="/core/controls/semantic-firewall/">Inside the semantic firewall &rarr;</a>
          <a class="airs-textlink airs-textlink--sm" href="/core/when-the-judge-can-be-fooled/">When the judge can be fooled &rarr;</a>
        </div>
      </div>
      <div class="airs-layerrow">
        <div class="airs-layerrow__meta">
          <p class="airs-layerrow__num">Layer 03</p>
          <p class="airs-layerrow__latency">as needed</p>
        </div>
        <div>
          <h2 class="airs-layerrow__title">Human oversight</h2>
          <p class="airs-layerrow__body">Escalation paths, audit trails, and a real person on the high-stakes decisions. The scope of oversight scales with the consequence: the more that rides on a call, the closer a human watches.</p>
          <a class="airs-textlink airs-textlink--sm" href="/core/oversight-readiness-problem/">Making oversight work &rarr;</a>
        </div>
      </div>
      <div class="airs-layerrow">
        <div class="airs-layerrow__meta">
          <p class="airs-layerrow__num">Layer 04</p>
          <p class="airs-layerrow__latency">instant</p>
        </div>
        <div>
          <h2 class="airs-layerrow__title">Circuit breakers</h2>
          <p class="airs-layerrow__body">The emergency stop. It halts the AI and fails over to a safe fallback when the other layers can't hold. You rarely need it, and you're very glad it's there when you do.</p>
          <a class="airs-textlink airs-textlink--sm" href="/pace-resilience/">PACE resilience &amp; fail-safe &rarr;</a>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="airs-section airs-section--card">
  <div class="airs-wrap">
    <p class="airs-eyebrow">Three domains</p>
    <h2 class="airs-h2">The same idea, at three scales.</h2>
    <p class="airs-intro">The same layered idea applies whether you are securing one agent, many agents, or the platforms beneath them.</p>
    <div class="airs-cards airs-cards--roles">
      <a class="airs-card" href="/foundations/">
        <p class="airs-card__title">Foundation</p>
        <p class="airs-card__body">One agent doing one job. This is where everyone starts, and where the four layers are easiest to see.</p>
        <span class="airs-card__more">Secure a single agent &rarr;</span>
      </a>
      <a class="airs-card" href="/maso/">
        <p class="airs-card__title">MASO</p>
        <p class="airs-card__body">Many agents working together. As they hand work to each other, trust gets complicated and the controls have to follow.</p>
        <span class="airs-card__more">Secure multi-agent systems &rarr;</span>
      </a>
      <a class="airs-card" href="/infrastructure/">
        <p class="airs-card__title">Infrastructure</p>
        <p class="airs-card__body">The platforms, cloud, tools, and data underneath it all, the layer everything else depends on.</p>
        <span class="airs-card__more">Secure the platform &rarr;</span>
      </a>
    </div>
  </div>
</section>

<section class="airs-section airs-section--paper" id="wider-boundary">
  <div class="airs-wrap">
    <p class="airs-eyebrow">The wider boundary</p>
    <h2 class="airs-h2">The layers act on more than words in and out.</h2>
    <p class="airs-intro">A request is the obvious thing to watch, but it is not the only one. The same four layers also bound what an agent is allowed to be, remember, trust, and spend. Treat these as factors to weigh when you place your controls, not afterthoughts.</p>
    <div class="airs-cards airs-cards--roles">
      <a class="airs-role" href="/core/iam-governance/">
        <p class="airs-role__title">Identity &amp; delegated authority</p>
        <p class="airs-role__roles">Who is the agent acting as, and how far does its borrowed authority reach? Scope it per action, not just at sign-up.</p>
      </a>
      <a class="airs-role" href="/core/memory-and-context/">
        <p class="airs-role__title">Memory &amp; context</p>
        <p class="airs-role__roles">What an agent stores and recalls is an attack surface. Poisoned memory can sit dormant and steer a later decision.</p>
      </a>
      <a class="airs-role" href="/insights/the-supply-chain-problem/">
        <p class="airs-role__title">Supply chain &amp; tool provenance</p>
        <p class="airs-role__roles">Models, tools, and their manifests arrive from somewhere. Trust what you can verify, not what claims to be safe.</p>
      </a>
      <a class="airs-role" href="/extensions/technical/economic-governance/">
        <p class="airs-role__title">Cost &amp; token governance</p>
        <p class="airs-role__roles">An agent that can loop or fan out can also burn a budget. Cap the blast radius before a runaway run does.</p>
      </a>
    </div>
  </div>
</section>

<section class="airs-section airs-section--paper">
  <div class="airs-wrap">
    <p class="airs-eyebrow">The thinking behind it</p>
    <h2 class="airs-h2">Why these layers, in this order.</h2>
    <p class="airs-intro">Six short reads make the whole case for runtime security: the why before the how.</p>
    <div class="airs-cards airs-cards--roles">
      <a class="airs-role" href="/insights/why-ai-security-is-a-runtime-problem/">
        <p class="airs-role__title">A runtime problem</p>
        <p class="airs-role__roles">Pre-deployment testing cannot prove future safety. Security has to be continuous.</p>
      </a>
      <a class="airs-role" href="/insights/why-guardrails-arent-enough/">
        <p class="airs-role__title">Guardrails aren't enough</p>
        <p class="airs-role__roles">Novel attacks and semantic violations walk straight past fixed rules.</p>
      </a>
      <a class="airs-role" href="/insights/judge-detects-not-decides/">
        <p class="airs-role__title">The judge detects</p>
        <p class="airs-role__roles">An evaluator surfaces unknown-bad against declared intent. It informs humans, not replaces them.</p>
      </a>
      <a class="airs-role" href="/insights/infrastructure-beats-instructions/">
        <p class="airs-role__title">Infrastructure beats instructions</p>
        <p class="airs-role__roles">Telling an agent what not to do fails. Make violations technically impossible.</p>
      </a>
      <a class="airs-role" href="/insights/humans-remain-accountable/">
        <p class="airs-role__title">Humans remain accountable</p>
        <p class="airs-role__roles">AI assists decisions; humans own outcomes. Oversight scales, it doesn't disappear.</p>
      </a>
      <a class="airs-role" href="/insights/feedback-loops/">
        <p class="airs-role__title">Feedback loops</p>
        <p class="airs-role__roles">Four loops at different speeds turn the layers into a self-improving system.</p>
      </a>
    </div>
    <a class="airs-textlink" href="/insights/">Browse all insights &rarr;</a>
  </div>
</section>

<section class="airs-section airs-section--card airs-center">
  <div class="airs-wrap--article">
    <h2 class="airs-h2">Not sure where to begin?</h2>
    <p class="airs-intro">Start with the plain-language explainer, or jump straight to the entry point that matches your role.</p>
    <div class="airs-btns">
      <a class="airs-btn airs-btn--primary" href="/what-is-ai-runtime-security/">What is AIRS? &rarr;</a>
      <a class="airs-btn airs-btn--secondary" href="/#roles">Find your role</a>
    </div>
  </div>
</section>
