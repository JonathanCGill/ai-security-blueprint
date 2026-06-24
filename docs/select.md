---
title: Build Your Control Set
description: "Declare what your AI does, set your risk posture, and get a matching, proportionate set of runtime controls you can tweak and take away as a checklist. Each control links back to its detail in the framework."
template: redesign.html
nav_active: framework
---

<section class="airs-section airs-hero airs-hero--narrow airs-section--paper airs-section--first">
  <div class="airs-wrap">
    <p class="airs-eyebrow airs-eyebrow--accent airs-hero__eyebrow">Control selector</p>
    <h1 class="airs-hero__title">The right controls, in the right amount.</h1>
    <p class="airs-hero__lead">Tell it what your AI does and how much is at stake. It returns a proportionate set of controls, grouped by class, each linked back to the framework. Tweak it, then take the checklist.</p>
  </div>
</section>

<section class="airs-section airs-section--card">
  <div class="airs-wrap airs-selector">

    <div class="airs-sel-step airs-sel-step--intent">
      <p class="airs-eyebrow">Step 1 &middot; Intent</p>
      <h2 class="airs-h2">What does your AI do?</h2>
      <p class="airs-intro">Pick what applies. These shape both the suggested risk tier and which classes of control are relevant.</p>
      <div class="airs-sel-toggles" id="airs-intent">
        <label><input type="checkbox" value="customer"> Customer-facing</label>
        <label><input type="checkbox" value="sensitive"> Handles sensitive or regulated data</label>
        <label><input type="checkbox" value="actions"> Takes actions or calls tools</label>
        <label><input type="checkbox" value="multiagent"> Multiple agents collaborate</label>
        <label><input type="checkbox" value="autonomous"> Operates autonomously</label>
      </div>
    </div>

    <div class="airs-sel-step airs-sel-step--posture">
      <p class="airs-eyebrow">Step 2 &middot; Risk posture</p>
      <h2 class="airs-h2">How much is at stake?</h2>
      <p class="airs-sel-suggest" id="airs-suggest"></p>
      <div class="airs-sel-controls">
        <div class="airs-sel-segment" id="airs-tiers">
          <button type="button" data-tier="1">Low</button>
          <button type="button" data-tier="2">Medium</button>
          <button type="button" data-tier="3">High</button>
          <button type="button" data-tier="4">Critical</button>
        </div>
        <div class="airs-sel-segment" id="airs-posture">
          <button type="button" data-posture="detect">Detect-only</button>
          <button type="button" data-posture="enforce">Enforcing</button>
        </div>
      </div>
      <p class="airs-sel-posturenote" id="airs-posturenote"></p>
    </div>

    <div class="airs-sel-step">
      <p class="airs-eyebrow">Step 3 &middot; Your control set</p>
      <h2 class="airs-h2" id="airs-count">Your control set</h2>
      <p class="airs-intro">Uncheck anything that does not apply to your context. Required for your tier is marked; recommended is a strong default. Each control links to its detail.</p>
      <div id="airs-results"></div>
      <div class="airs-sel-actions">
        <button type="button" id="airs-copy" class="airs-btn airs-btn--primary">Copy as checklist</button>
        <button type="button" id="airs-print" class="airs-btn airs-btn--secondary">Print</button>
      </div>
    </div>

  </div>
</section>

<script>
(function () {
  var CLASSES = [
    ["guardrails", "Guardrails"],
    ["reviewing", "Reviewing controls"],
    ["oversight", "Human oversight"],
    ["breaker", "Circuit breakers & resilience"],
    ["identity", "Identity & access"],
    ["data", "Data protection"],
    ["supply", "Supply chain"],
    ["observability", "Observability"]
  ];
  var TIERS = { 1: "Low", 2: "Medium", 3: "High", 4: "Critical" };
  var C = [
    {id:"g-in", cls:"guardrails", name:"Input guardrails", sum:"Block prompt injection, PII, and out-of-scope inputs before the model sees them.", rec:1, req:2, link:"/core/controls/"},
    {id:"g-out", cls:"guardrails", name:"Output guardrails", sum:"Filter PII, unsafe content, and format violations before a response leaves the system.", rec:1, req:2, link:"/core/controls/"},
    {id:"g-rate", cls:"guardrails", name:"Rate limits & consumption caps", sum:"Cap request volume and token spend to contain runaway loops and abuse.", rec:2, req:3, link:"/infrastructure/controls/network-and-segmentation/"},
    {id:"g-tool", cls:"guardrails", name:"Tool permission scoping", sum:"Allow-list the tools and parameters each agent may use. If it is not listed, it cannot be called.", req:3, requires:["actions"], link:"/maso/controls/execution-control/"},

    {id:"r-scan", cls:"reviewing", name:"Deterministic scanners", sum:"Pattern, PII, and secret scanners as the first, cheapest review pass.", rec:1, req:2, link:"/core/controls/"},
    {id:"r-sem", cls:"reviewing", name:"Semantic firewall", sum:"An intent classifier that flags requests whose meaning matches a prohibited topic, even when the wording is novel.", rec:2, req:3, link:"/core/controls/semantic-firewall/"},
    {id:"r-judge", cls:"reviewing", name:"Model-as-Judge evaluation", sum:"An independent model evaluates outputs against policy, grounding, and intent.", rec:2, req:3, link:"/core/judge-assurance/"},
    {id:"r-intent", cls:"reviewing", name:"Declared Objective Intent", sum:"A versioned spec of what each agent or workflow should do, for the judge to rule against.", req:3, requires:["actions","multiagent"], link:"/maso/controls/objective-intent/"},
    {id:"r-strat", cls:"reviewing", name:"Strategic cross-agent evaluation", sum:"Evaluate the combined workflow, not just each agent, to catch failures that emerge across hand-offs.", req:3, requires:["multiagent"], link:"/maso/reference/#evaluation-architecture-inline-vs-offline"},

    {id:"o-review", cls:"oversight", name:"Human review of flagged outputs", sum:"A person reviews what the automated layers escalate. Sampling at low risk, more as stakes rise.", rec:1, req:2, link:"/core/oversight-readiness-problem/"},
    {id:"o-approve", cls:"oversight", name:"Human approval for high-impact actions", sum:"Require a person to approve consequential or irreversible actions before they commit.", req:3, requires:["actions"], link:"/maso/implementation/tier-1-supervised/"},
    {id:"o-dual", cls:"oversight", name:"Dual approval for critical actions", sum:"Two-person sign-off, and a dry-run, for the highest-stakes actions.", req:4, requires:["actions"], link:"/maso/implementation/tier-1-supervised/"},
    {id:"o-audit", cls:"oversight", name:"Audit trail & decision records", sum:"Keep an accountable record of who or what decided, and why.", rec:1, req:2, link:"/infrastructure/controls/logging-and-observability/"},
    {id:"o-priv", cls:"oversight", name:"Privileged agent governance", sum:"Elevated controls and approval gates for orchestrators and planners that direct other agents.", req:3, requires:["multiagent"], link:"/maso/controls/privileged-agent-governance/"},

    {id:"b-cb", cls:"breaker", name:"Circuit breaker & safe fallback", sum:"Halt the AI and switch to a non-AI fallback when a layer fails.", rec:2, req:3, link:"/pace-resilience/"},
    {id:"b-pace", cls:"breaker", name:"PACE fail postures", sum:"Define and test the safe state each layer falls back to, from degraded mode to full stop.", req:3, link:"/pace-resilience/"},
    {id:"b-blast", cls:"breaker", name:"Blast radius caps", sum:"Limit how much any single agent can do before a breaker trips.", req:3, requires:["actions"], link:"/maso/controls/execution-control/"},
    {id:"b-kill", cls:"breaker", name:"External kill switch", sum:"A stop that lives outside the agent and its orchestration, so it works even if the agent does not cooperate.", req:4, requires:["actions","autonomous"], link:"/maso/environment-containment/"},

    {id:"i-auth", cls:"identity", name:"Authenticate all callers", sum:"Every human and non-human caller is authenticated before it can invoke the AI.", req:1, link:"/infrastructure/controls/identity-and-access/"},
    {id:"i-lp", cls:"identity", name:"Least privilege", sum:"Grant the minimum permissions needed, with nothing inherited by default.", req:1, link:"/infrastructure/controls/identity-and-access/"},
    {id:"i-cred", cls:"identity", name:"Short-lived scoped credentials", sum:"Session-scoped tokens that expire and can be revoked, never long-lived shared keys.", rec:2, req:3, link:"/infrastructure/controls/secrets-and-credentials/"},
    {id:"i-nhi", cls:"identity", name:"Per-agent identity, no shared credentials", sum:"Each agent gets its own non-human identity so a compromise can be scoped and revoked.", req:3, requires:["multiagent"], link:"/maso/controls/identity-and-access/"},
    {id:"i-bus", cls:"identity", name:"Secure inter-agent message bus", sum:"All agent-to-agent traffic passes through a signed, validated, rate-limited channel.", req:3, requires:["multiagent"], link:"/maso/distributed-architecture/"},

    {id:"d-class", cls:"data", name:"Data classification at AI boundaries", sum:"Know what class of data crosses into and out of the model.", rec:2, req:3, requires:["sensitive"], link:"/infrastructure/controls/data-protection/"},
    {id:"d-pii", cls:"data", name:"PII detection & redaction", sum:"Detect and redact sensitive data in model inputs, outputs, and logs.", req:2, requires:["sensitive"], link:"/infrastructure/controls/data-protection/"},
    {id:"d-rag", cls:"data", name:"Access-controlled RAG", sum:"Enforce each user's own access rights on what retrieval can surface.", req:3, requires:["sensitive"], link:"/maso/controls/data-protection/"},
    {id:"d-dlp", cls:"data", name:"Output DLP", sum:"Catch sensitive data leaving in responses or inter-agent messages.", req:3, requires:["sensitive"], link:"/infrastructure/controls/data-protection/"},

    {id:"s-prov", cls:"supply", name:"Model provenance & risk assessment", sum:"Know where each model came from and assess its security posture before adoption.", rec:1, req:2, link:"/maso/controls/supply-chain/"},
    {id:"s-tool", cls:"supply", name:"Tool & MCP vetting", sum:"Vet and sign tool and MCP server components, and verify integrity at runtime.", req:3, requires:["actions"], link:"/maso/controls/supply-chain/"},
    {id:"s-bom", cls:"supply", name:"AI-BOM and component inventory", sum:"Inventory models, tools, and dependencies, and monitor them for vulnerabilities.", rec:2, req:3, link:"/infrastructure/agentic/supply-chain/"},

    {id:"ob-io", cls:"observability", name:"Log all model I/O", sum:"Capture every input and output. You cannot evaluate what you do not record.", req:1, link:"/infrastructure/controls/logging-and-observability/"},
    {id:"ob-drift", cls:"observability", name:"Behavioural drift detection", sum:"Compare current behaviour against a baseline to catch slow drift.", req:3, link:"/maso/controls/observability/"},
    {id:"ob-anom", cls:"observability", name:"Anomaly scoring & alerting", sum:"Score per-call anomalies and alert when they cross a threshold.", rec:2, req:3, link:"/maso/controls/observability/"},
    {id:"ob-siem", cls:"observability", name:"SIEM correlation", sum:"Feed AI events into your SIEM to correlate with network, endpoint, and application activity.", req:3, link:"/infrastructure/controls/logging-and-observability/"},
    {id:"ob-fr", cls:"observability", name:"Flight recorder", sum:"An immutable, tamper-evident trace of every action, verdict, and hand-off.", req:3, requires:["multiagent"], link:"/maso/controls/observability/"}
  ];

  var intent = {};
  var tier = 1, tierManual = false, posture = "detect";
  var off = {};

  var $intent = document.getElementById("airs-intent");
  var $tiers = document.getElementById("airs-tiers");
  var $posture = document.getElementById("airs-posture");
  var $suggest = document.getElementById("airs-suggest");
  var $posturenote = document.getElementById("airs-posturenote");
  var $results = document.getElementById("airs-results");
  var $count = document.getElementById("airs-count");

  function suggested() {
    var t = 1;
    if (intent.customer) t = Math.max(t, 2);
    if (intent.sensitive) t = Math.max(t, 3);
    if (intent.actions) t = Math.max(t, 3);
    if (intent.multiagent) t = Math.max(t, 3);
    if (intent.autonomous) t = 4;
    return t;
  }
  function applies(c) {
    if (!c.requires || !c.requires.length) return true;
    for (var i = 0; i < c.requires.length; i++) if (intent[c.requires[i]]) return true;
    return false;
  }
  function statusOf(c) {
    if (tier >= c.req) return "req";
    if (c.rec && tier >= c.rec) return "rec";
    return null;
  }
  function selected() {
    return C.filter(function (c) { return applies(c) && statusOf(c) && !off[c.id]; });
  }

  function esc(s) { return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;"); }

  function render() {
    // sync tier/posture buttons
    Array.prototype.forEach.call($tiers.children, function (b) { b.classList.toggle("is-on", +b.dataset.tier === tier); });
    Array.prototype.forEach.call($posture.children, function (b) { b.classList.toggle("is-on", b.dataset.posture === posture); });

    var sug = suggested();
    $suggest.innerHTML = "Suggested tier from your intent: <strong>" + TIERS[sug] + "</strong>." +
      (tierManual && tier !== sug ? " You have set it to <strong>" + TIERS[tier] + "</strong>." : "");
    $posturenote.textContent = posture === "detect"
      ? "Detect-only: enforcing controls run in shadow and log what they would have done. Move to enforcing once you trust the signal."
      : "Enforcing: guardrails block, the judge can hold high-risk actions, and breakers trip automatically.";

    var html = "", shown = 0;
    CLASSES.forEach(function (pair) {
      var rows = C.filter(function (c) { return c.cls === pair[0] && applies(c) && statusOf(c); });
      if (!rows.length) return;
      html += '<div class="airs-sel-group"><p class="airs-sel-group__title">' + pair[1] + '</p><div class="airs-sel-list">';
      rows.forEach(function (c) {
        var st = statusOf(c);
        var on = !off[c.id];
        if (on) shown++;
        var badge = st === "req"
          ? '<span class="airs-sel-badge airs-sel-badge--req">Required</span>'
          : '<span class="airs-sel-badge airs-sel-badge--rec">Recommended</span>';
        html += '<div class="airs-sel-ctrl' + (on ? "" : " airs-sel-ctrl--off") + '">' +
          '<input type="checkbox" data-id="' + c.id + '"' + (on ? " checked" : "") + '>' +
          '<div><div class="airs-sel-ctrl__name"><a href="' + c.link + '">' + esc(c.name) + '</a></div>' +
          '<div class="airs-sel-ctrl__sum">' + esc(c.sum) + '</div></div>' +
          badge + '</div>';
      });
      html += '</div></div>';
    });
    if (!shown && !html) html = '<p class="airs-sel-empty">No controls match yet. Pick an intent or raise the tier.</p>';
    $results.innerHTML = html;
    $count.textContent = shown + " control" + (shown === 1 ? "" : "s") + " for " + TIERS[tier] + " risk, " + (posture === "detect" ? "detect-only" : "enforcing");
  }

  $intent.addEventListener("change", function (e) {
    if (e.target.type !== "checkbox") return;
    intent[e.target.value] = e.target.checked;
    if (!tierManual) tier = suggested();
    render();
  });
  $tiers.addEventListener("click", function (e) {
    if (!e.target.dataset.tier) return;
    tier = +e.target.dataset.tier; tierManual = true; render();
  });
  $posture.addEventListener("click", function (e) {
    if (!e.target.dataset.posture) return;
    posture = e.target.dataset.posture; render();
  });
  $results.addEventListener("change", function (e) {
    if (e.target.type !== "checkbox") return;
    off[e.target.dataset.id] = !e.target.checked;
    render();
  });

  document.getElementById("airs-copy").addEventListener("click", function () {
    var sel = selected();
    var origin = location.origin;
    var lines = ["# My AIRS control set",
      "Risk tier: " + TIERS[tier] + " | Posture: " + (posture === "detect" ? "Detect-only" : "Enforcing"),
      "Intent: " + (Object.keys(intent).filter(function (k) { return intent[k]; }).join(", ") || "none selected"),
      ""];
    CLASSES.forEach(function (pair) {
      var rows = sel.filter(function (c) { return c.cls === pair[0]; });
      if (!rows.length) return;
      lines.push("## " + pair[1]);
      rows.forEach(function (c) {
        var st = statusOf(c) === "req" ? "required" : "recommended";
        lines.push("- [ ] " + c.name + " (" + st + "): " + origin + c.link);
      });
      lines.push("");
    });
    var text = lines.join("\n");
    var done = function () { var b = document.getElementById("airs-copy"); var t = b.textContent; b.textContent = "Copied"; setTimeout(function () { b.textContent = t; }, 1500); };
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text).then(done, function () { window.prompt("Copy your checklist:", text); });
    } else { window.prompt("Copy your checklist:", text); }
  });
  document.getElementById("airs-print").addEventListener("click", function () { window.print(); });

  render();
})();
</script>
