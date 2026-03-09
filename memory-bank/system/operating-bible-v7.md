# SLUICE TECHNOLOGIES: Complete Operating Bible

**The Autonomous AI Business Operating System**

v8.0 | March 2026

---

## Part I: Core Thesis

Sluice Technologies is an autonomous AI system that creates, operates, and scales digital businesses. Each business has its own budget, its own AI management team, and its own P&L. The system gets smarter with every business it operates.

One company owns everything: **Sluice Technologies** (not yet incorporated, will incorporate when prod Stripe is needed). The exit is selling this company for $1B+. The buyer pays for a proven autonomous business operating system, not for the portfolio of individual businesses.

### The Three Constraints

Everything in this document flows from three non-negotiable constraints:

**1. Revenue:** $1B at 15-25x revenue requires $40-67M ARR. Individual businesses must reach $100K+ MRR. Small tools with $2-5K MRR ceilings are experiments, not portfolio businesses.

**2. Distribution:** There is no human sales process. Zero calls, demos, outbound, or contracts. The sales engine is SEO (people Google their problem, find us) and short-form video/reels (people see the product in action, click through, sign up). AI manages both channels end-to-end.

**3. Self-serve:** Every product is credit-card checkout. Users find it, try it, pay. The product is the sales process.

### The Double Filter

Every business idea must pass both tests before building begins:

- **Revenue Ceiling Test:** Can this plausibly reach $100K MRR through self-serve?
- **Distribution Test:** Can SEO and/or reels be the primary acquisition channel?

If either answer is no, don't build it.

### Corporate Structure

Delaware C Corp via Stripe Atlas ($500) or Clerky ($500-800). 10M shares common at $0.00001 par value. 10-15% option pool. 83(b) within 30 days. Foreign corp registration in Ohio (~$99). All IP assigned to corporation. Annual costs ~$400-500.

---

## Part II: What We Build

### Business Types That Pass Both Filters

**SMB Vertical Tools ($50-200/month)** are the highest-value category.

Small business owners Google everything: "yoga studio scheduling software," "dog grooming booking system," "photography client portal." These are high-intent, transactional, low-competition keywords. Reels showing real business transformation convert: "How I manage my entire dog grooming business from my phone."

1,000 customers at $100/month = $100K MRR. Millions of small businesses per vertical. Each vertical has unique requirements (yoga studios need class scheduling; dog groomers need pet profiles), which creates defensible niches. Monthly churn typically 3-5% because switching costs are enormous once client data, scheduling, and payments are migrated.

Examples: all-in-one tools for pet services, fitness/wellness studios, home services, tutoring/coaching, photography, salons, auto repair, music teachers, event planners, food trucks.

**Prosumer Workflow Tools ($20-80/month)** for individual professionals.

SEO: "free invoice template" (convert to tool), "client proposal generator," "social media scheduler for creators." Reels: screen recordings showing before/after, "I used to spend 3 hours on this, now it takes 5 minutes."

2,500 paying users at $40/month = $100K MRR. Achievable with 50-100 SEO articles targeting long-tail keywords and 3-5 reels/week.

Examples: proposal builders for freelancers, portfolio builders, client management for consultants, AI headshot/photo tools, content repurposing tools, meeting notes tools.

**PLG Platforms ($15-50/month, freemium)** where free usage creates distribution.

User-generated content creates SEO surface area (public pages, templates, profiles). Users share outputs, creating organic marketing. Free tier IS the distribution.

4,000 paid users at $25/month = $100K MRR. Requires 100-200K free users at 2-4% conversion. Ambitious but achievable with strong viral mechanics.

### What NOT to Build

Anything where the buyer doesn't Google the problem. Anything where value can't be shown in a 30-second video. Developer tools/APIs (developers find tools through GitHub/HN, not Google/reels). Anything requiring demos. AI wrappers with no defensible layer. Direct competition with well-funded incumbents on the same keywords. Enterprise products requiring procurement.

### Product Design for Distribution

Every product includes from day one:

**For SEO:** Blog/content section targeting 30-50 keywords. Free tool or calculator page ranking for high-volume informational keywords (e.g., free invoice template generator funnels users to the full invoicing product). Public template galleries or resource pages creating indexable content. Technical SEO baked in: fast loads, structured data, meta tags, sitemap.

**For Reels:** At least one feature producing a visible before/after or "watch me do this" moment. Results that look impressive on screen. A workflow demonstrable in 15-30 seconds. Templates creating instant "wow" moments.

**For Retention:** Data accumulates over time. Workflow integration making switching painful. Expansion pricing (base tier to team/premium).

---

## Part III: The Agent Hierarchy

```
YOU (Human Layer)
  Daily: 15 min reviewing decisions. Weekly: 1hr on portfolio.
  80%: building and improving the system.

PORTFOLIO ORCHESTRATOR (Claude Opus, weekly)
  Cross-portfolio intelligence, capital allocation, kill/scale, patterns.

CEO AGENT (Claude Opus, daily per business)
  Brain of each business. Cross-functional decisions. Weekly plans.
  Content strategy ownership (SEO + reels = revenue).

COMPTROLLER AGENT (Claude Opus, multi-horizon)
  Adversarial reviewer. Challenges assumptions upstream.

FUNCTIONAL AGENTS (per business)
  Product Agent (Opus)     | Marketing Agent (Sonnet)
  Support Agent (Haiku)    | Finance Agent (Haiku)
  Content Agent (Sonnet)
```

**The Content Agent and Marketing Agent are the revenue team.** They get the most attention, the most sophisticated prompts, and the most monitoring. A good-enough product with excellent SEO and reels reaches $100K MRR. A perfect product with no traffic generates zero.

### The CEO Agent

Holds the unified mental model of each business. Makes cross-functional decisions. Owns content/distribution strategy (which keywords, which reel themes, channel allocation).

**Daily:** Read functional agent reports, assess fires, issue directives, update state.
**Weekly:** Generate implementation plan with priorities for each agent, heavy emphasis on content calendar and SEO targets. Submit to Comptroller. Finalize after feedback.

**Memory Bank (APM-inspired):**

```
/forge/businesses/[id]/
  state.md              # Status, health, metrics
  strategy.md           # Market, channels, pricing, PLG mechanics
  content-strategy.md   # Keywords, reel themes, calendar, performance
  weekly-plan.md        # This week's plan
  reports/              # Structured reports from each agent
  comptroller/          # Reviews, overrides
  history/              # Decisions, pivots, archived plans
```

State persists in files, not conversation history. Context-fresh instances read memory bank and pick up seamlessly. Handover documents capture tacit knowledge when resetting.

**Structured Report Format (all agents):**

```markdown
## [Agent] | [Business] | [Date]
Status: GREEN / YELLOW / RED
### Key Metrics (3-5, with trends)
### Actions Taken (outcomes)
### Issues Detected
### Recommendations
### Needs from CEO Agent
```

### The Comptroller

Catches problems before they become crises. Operates at three time horizons:

**Weekly Plan Review (every business, before execution).** Five first-principles questions: Does the plan match reality? Right strategy or sunk cost? What's the implicit assumption? Failure scenario? What would I do differently? Plus three content-specific: Rankable keywords? Reels producing signups or just views? Content ROI trending correctly?

**Early Warning Triggers (automatic).** Revenue drops 20%+ WoW. ROAS below 1.5 for 14 days. Support tickets spike 3x. Spend exceeds 2x revenue over 14 days. Free-to-paid conversion drops 30%. Churn exceeds 10% two consecutive months. Organic traffic drops 25%+ MoM. Zero reel-attributed signups for 14+ days.

**Monthly Aggregate Review.** CEO Agent decision patterns. Biases. Ignored recommendations. Cross-business comparisons. Content strategy effectiveness by stage.

**New Business Viability Review.** Before building: Revenue Ceiling Test, Distribution Test (keyword volumes, reel potential, competitive landscape), failure modes, portfolio overlap.

Cost: ~120-160 Opus calls/month at 50 businesses. $10-25/month.

### Functional Agents

**Product Agent (Opus):** Sentry monitoring, auto-fix (>5 errors same endpoint = fix cycle). PostHog usage analytics, A/B testing. Build and maintain SEO infrastructure: blog CMS, free tool pages, template galleries, structured data. Execute weekly plan priorities.

**Marketing Agent (Sonnet):** The most critical revenue agent. SEO weekly (Ahrefs rankings, content refresh, keyword opportunities, Google Search Console submissions). Ads daily (Google Ads, Meta: ROAS tracking, pause/scale). Social daily (Mixpost). Video coordination (Content Agent scripts to video pipeline). Directories at launch (Stagehand submissions).

**Content Agent (Sonnet):** Blog posts (2-4/week per business), reel scripts (3-5/week), email campaigns, video scripts. All through Content Quality Standards review. Follows CEO Agent content strategy.

**Support Agent (Haiku):** 70-80% auto-resolution. Churn prevention. Onboarding drip (5-email via Loops).

**Finance Agent (Haiku):** Daily reconciliation. Weekly P&L with channel attribution. CAC, LTV, payback. Monthly treasury.

---

## Part IV: The Tool Belt

Every tool choice rigorously validated against alternatives. One tool per function.

### Orchestration

| Function | Tool | Why |
|----------|------|-----|
| Workflow orchestration | **n8n** (self-hosted) | 1,200+ integrations, visual editor, native AI nodes, custom JS/Python code steps, self-hostable (free), $2.5B valuation company with strong trajectory. Confirmed best-in-class after evaluating Make, Zapier, Activepieces. |
| Web monitoring | **Huginn** (self-hosted) | Monitors changelogs, competitor sites, review sites, price changes. Feeds signals into n8n. Lightweight, runs on same server. |

### Code & Deployment

| Function | Tool | Why |
|----------|------|-----|
| Product creation | **Claude Code** (CLI) | Builds full-stack apps from specs. The creation engine. |
| Source control | **GitHub API** | Repos, branches, CI/CD. Free public repos. |
| Frontend hosting | **Vercel** | Free tier handles significant traffic. Auto-deploys from GitHub. Edge network. |
| Backend/workers | **Railway** | Container deployment, cron jobs, workers. Usage-based. |
| Database + auth + storage | **Supabase** | PostgreSQL + auth + storage + realtime + edge functions in one platform. Confirmed best choice: eliminates 4 separate services (DB, auth, storage, realtime). Free tier: 500MB, 50K MAU. Pro: $25/month. |
| Cache/queue | **Upstash Redis** | Serverless. Pay-per-request. Rate limiting, job queues, caching. |

### Web Automation

| Function | Tool | Why |
|----------|------|-----|
| Browser automation (production) | **Stagehand** | TypeScript (matches Next.js stack). Extends Playwright with AI methods (act, extract, observe). Caches AI decisions for speed. Self-heals when selectors break. <5% maintenance vs 15-25% for pure Playwright scripts. 10K+ GitHub stars. Better than Browser Use for repeatable production workflows. |
| Browser automation (exploration) | **Browser Use** | Python. Full autonomous agent control. 89% WebVoyager success. Best for one-off exploratory tasks (competitor research, novel form filling). 50K+ GitHub stars. |
| Web scraping | **Firecrawl** | Any URL to clean markdown/JSON. Handles JS, proxies, anti-bot. 95% success rate. Free 1K pages/month. |

### Payments

| Function | Tool | Why |
|----------|------|-----|
| Payments | **Stripe** | Industry standard. Checkout, subscriptions, billing portal, webhooks. |
| Sales tax | **Stripe Tax** | 0.5% per transaction. Automatic calculation. |

### Marketing & Distribution

| Function | Tool | Why |
|----------|------|-----|
| SEO research | **Ahrefs Lite** ($99/mo) | Keyword research API, rank tracking, backlink analysis. The standard. |
| Search indexing | **Google Search Console API** | Free. Submit URLs, check index, search analytics. |
| Social scheduling | **Mixpost** (self-hosted) | Open-source. Posts to TikTok, Twitter, Instagram, LinkedIn, YouTube. No per-post costs. |
| Search ads | **Google Ads API** | Programmatic campaign creation, budget, ROAS. |
| Social ads | **Meta Marketing API** | Facebook + Instagram. Programmatic management. |

### Content Production

| Function | Tool | Why |
|----------|------|-----|
| Writing | **Claude Sonnet** (API) | Blog posts, copy, emails, scripts. With Content Quality Standards. |
| Short-form video (AI) | **Revid.ai** ($19-29/mo) | Text to short-form video. Analyzes viral patterns. Auto-publishes. API for programmatic use. |
| UI generation | **v0.dev** ($20/mo) | AI generates production-quality React/Next.js using shadcn/ui + Tailwind. |

### Content Quality Ladder (AI to Human UGC)

| Stage | Content Mix | Tools | Monthly Content Spend |
|-------|------------|-------|----------------------|
| **Seed** ($0-2K MRR) | 100% AI. Revid.ai reels, Claude blog posts. Volume over polish. Validate demand. | Revid.ai, Claude Sonnet | $20-50 |
| **Traction** ($2-10K MRR) | 80% AI, 20% UGC. Keep AI for SEO + organic social. Add 3-5 real UGC videos/month for paid ads. | + **Billo** ($50-70/video) | $200-400 |
| **Scale** ($10-50K MRR) | 60% AI, 40% UGC. AI handles all written content + organic. UGC handles paid social (higher conversion, authentic). 10-20 UGC videos/month. | + **SideShift Growth** ($299/mo) | $600-1,500 |
| **Breakout** ($50K+ MRR) | 40% AI, 60% UGC. Aggressive UGC-powered paid social. 30-50+ videos/month. AI still handles SEO, email, organic. | **SideShift Scale** ($999/mo) | $2,000-5,000 |

### Email

| Function | Tool | Why |
|----------|------|-----|
| Transactional | **Resend** | Clean API, good deliverability. Free 3K/month. |
| Marketing/drip | **Loops** | Built for SaaS. Event-triggered flows. Free up to 1K contacts. |

### Monitoring & Analytics

| Function | Tool | Why |
|----------|------|-----|
| Errors | **Sentry** | Stack traces, performance. Free 5K events/month. |
| Uptime | **UptimeRobot** | Free 50 monitors. Covers entire portfolio. |
| Web analytics | **Plausible** ($9/mo) | Privacy-friendly. Lightweight. No cookie banner. Up to 50 sites. |
| Product analytics | **PostHog** (self-hosted) | Sessions, feature flags, A/B testing, funnels. Self-hosted = free. |

### Infrastructure & Legal

| Function | Tool | Why |
|----------|------|-----|
| Domains + DNS + CDN | **Cloudflare** | Wholesale domains (~$10). Free DNS, CDN, SSL. API for everything. |
| Legal compliance | **Termly** ($10/mo) | Auto-generated privacy policy + TOS. GDPR, CCPA. Multiple sites. |

**Total monthly tooling: ~$450-650** + AI API costs $400-900 (including CEO + Comptroller calls).

---

## Part V: Content Quality Standards

Content IS the sales engine. AI-sounding content destroys trust, hurts SEO, kills conversion.

**Banned:** Em dashes. "Delve," "leverage" (verb), "utilize," "harness," "elevate," "empower," "streamline," "robust," "seamless," "cutting-edge," "tapestry." "In today's landscape." "It's important to note." "Game-changer," "dive in," "without further ado." Sentences starting "In the realm of." Excessive enthusiasm. Numbered lists where prose works.

**Required:** Write like a person with opinions. Contractions. Surprising observations. Specific numbers and examples. Varied sentence length. Specific action steps. Platform-native voice.

**For reel scripts:** Sound like a real person talking. Casual, fast, direct. Start with result or hook ("This just saved me 4 hours"), not setup. No corporate voice. Get to the point in 2 seconds.

**Review loop:** Haiku checks every piece for banned patterns before publishing. $0.001/review.

---

## Part VI: Design Quality Standards

Every product looks professionally designed. Trust drives conversion.

**Pipeline:** v0.dev generates initial UI from detailed brief. Claude Code refines with CLAUDE.md design system. Product Agent quality gate.

**CLAUDE.md standards:** Unique font pairing per product (never Inter/Roboto/Arial). Unique palette via CSS variables. Aesthetic matched to audience (glassmorphism, editorial, bold modern, dark luxury). Staggered animations, hover states, parallax. Structured landing page (hero, problem, solution, how-it-works, social proof, pricing, FAQ, footer). No stock photos, no generic SVGs, no uncustomized defaults.

**Quality gate:** Lighthouse > 90. Mobile responsive. Unique fonts + palette. 3+ custom animations. Content review passed. Meta tags + OG image. Favicon.

---

## Part VII: Why Not Agent Frameworks

Agents communicate through persistent markdown files and structured reports. Not live conversation. CEO Agent reads reports, writes plans. Functional agents read plans, execute, write reports. Asynchronous, persistent, inspectable, debuggable.

n8n orchestrates. Claude reasons. Markdown files persist memory. No framework needed.

---

## Part VIII: Identifying New Businesses

Every idea must pass the Double Filter (Revenue Ceiling + Distribution Test). The sourcing system runs continuously via Huginn agents feeding raw signals into a Supabase table. Daily, Claude Opus scores the top candidates on five dimensions: demand evidence, feasibility for AI build, monetization clarity, competition gap, and distribution viability. Anything scoring 6.5+ is surfaced for your 10-15 minute daily review.

### Tier 1: Clone-and-Improve Proven Models (Highest Hit Rate)

Scrape Acquire.com for SaaS businesses sold at $500K-5M (implies $10-100K+ MRR). Study their product, pricing, reviews, and critically their SEO profile via Ahrefs: what keywords drive their traffic? How much organic traffic? If a business sold for $2M and gets 50K organic visits/month, that's proven distribution. Build a better, cheaper, or more niche-specific version targeting the same keywords.

Also study fastest-growing products in target SMB categories on G2 and Capterra. Read their 1-2 star reviews. Those reviews tell you exactly what to build.

Scrape IndieHackers open revenue dashboards for businesses at $10-50K MRR. These are proven models at a scale where AI can compete.

### Tier 2: Underserved SMB Verticals

Systematically Google "[industry] software" for hundreds of SMB verticals. For each: Are the top results ugly, expensive, or generic? Use Ahrefs to validate keyword volume: if "[vertical] scheduling software" + "[vertical] booking system" + "[vertical] management software" collectively have 5,000+ monthly searches, there's a market.

Cross-reference with reel potential: can you demonstrate this tool managing a real business in a 30-second video? If both SEO and reels work, this passes the Double Filter.

Set up Huginn agents to monitor Google Trends for rising "[industry] + software" searches. New verticals emerge as industries digitize.

### Tier 3: Platform Ecosystem Plays

When Shopify, Stripe, Vercel, Supabase, or other major platforms ship new APIs or capabilities, there's a 2-4 week window before anyone builds tools for them. Shopify apps regularly reach $100K+ MRR. Stripe ecosystem tools likewise.

Huginn monitors changelogs and release notes for: Shopify, Stripe, Vercel, Supabase, Notion, Figma, Linear, GitHub, Slack, HubSpot.

### Tier 4: Keyword and Demand Signals

Ahrefs API for keywords with >1K monthly searches, keyword difficulty < 30, and weak top results (low DA sites ranking, outdated content, poor UX). These are unmet demand signals.

Reddit/forum monitoring via Huginn: pattern match "I wish...", "Does anyone know a tool for...", "I'm paying X for Y and it's terrible" across r/SaaS, r/smallbusiness, r/Entrepreneur, and vertical-specific subreddits.

Failed Product Hunt launches (50-150 upvotes, then went dark): real insight, poor execution. Firecrawl scrapes PH, Claude categorizes.

App store review mining: 1-2 star reviews on Chrome Web Store, Shopify App Store, and vertical software directories scraped via Firecrawl, categorized by Claude. Recurring complaints = build opportunity.

### The Pipeline in Practice

Huginn agents monitor all Tier 1-4 sources continuously, feeding raw signals into a Supabase `opportunities` table. Each signal includes: source, category, estimated keyword volume, competition level, reel potential score, and raw data. Daily, Claude Opus scores the top 10-15 candidates. You review for 10-15 minutes, approve the best, reject the rest. Approved opportunities enter the creation pipeline below.

---

## Part IX: Budget Mechanism

Each business has its own balance. Revenue via Stripe webhook. Spending debited. CEO Agent sets allocation weekly.

**Budget tiers (content-heavy, because content IS sales):**

| Stage | Daily Max | Content/SEO | Paid Ads | Product | Reserve |
|-------|:---------:|:-----------:|:--------:|:-------:|:-------:|
| Seed ($0-2K MRR) | $20 | 60% | 0% | 25% | 15% |
| Traction ($2-10K MRR) | $100 | 45% | 20% | 15% | 20% |
| Scale ($10-50K MRR) | $500 | 30% | 35% | 15% | 20% |
| Breakout ($50K+ MRR) | $2,000 | 20% | 45% | 15% | 20% |

Note: "Content" includes UGC spend at traction+ stages. "Paid Ads" only activates after organic proves conversion. No paid ads at seed stage. Ever.

**Circuit breakers (system-level, no override):**
- Per-action: $25 without approval (seed/traction), $100 (scale), $500 (breakout)
- 7-day spend > 3x trailing revenue: auto-pause
- All campaigns: positive ROAS within 72 hours or pause
- Churn > 15%: pause acquisition, redirect to retention
- Organic traffic drops 40%+ in a month: emergency review

---

## Part X: Execution Roadmap

### Month 1: Build Everything

**Week 1:** Incorporate. Mercury bank. All accounts. n8n + Huginn on Railway. Database schema. Budget system. Memory bank structure.

**Week 2:** CEO Agent v1. Comptroller v1. Support Agent. Finance Agent. Monitoring Agent. Structured reports.

**Week 3:** Creation pipeline (v0.dev + Claude Code). Content Agent. Marketing Agent (SEO + Mixpost + Revid.ai). Product Agent.

**Week 4:** 3-5 ideas passing both filters. Launch 3 businesses. Everything through system. Content engine starts day one.

**Capital: $1,500-2,000**

### Months 2-3: Validate Distribution

Primary focus: prove AI-managed SEO + reels acquire customers. Track: organic traffic growth, reel signups, keyword rankings, CAC by channel.

Marketing Agent v2: Google Ads ($10-20/day, highest-intent keywords only after organic proves conversion).

Kill anything with zero traction after 60 days.

**Target: $2,000-8,000 MRR. AOR: 50-65%**

### Months 4-6: Scale Winners

5-8 launches/month. Portfolio: 20-35 launched, 5-10 active. Winners move to Traction budget. First UGC videos via Billo for businesses at $5K+ MRR. First Acquire.com sale. Content intelligence compounding.

**Target: $15,000-40,000 MRR. AOR: 65-80%**

### Months 7-12: Push to $100K

2-3 businesses past $30K MRR. Increased product depth. UGC-powered paid social via SideShift. Hire first engineer.

**Target: $80,000-180,000 MRR. 1-3 businesses > $50K. AOR: 80-90%**

---

## Part XI: Honest Assessment

**$5M+ ARR in 2 years: 30-45%.** Genuinely achievable.

**$500K-1M/year personal income in 2 years: 35-50%.** Most likely good outcome.

**The make-or-break experiment (months 2-3):** For the first 3 businesses, track: organic traffic growth/week, keyword ranking velocity, reel views-to-signup rate, overall CAC. If after 90 days at least one business acquires 50+ organic signups/month and growing, the model is validated. If none are, the content engine needs fundamental rethinking.

**The hardest part is distribution, not building.** Can AI-managed SEO + reels reliably acquire customers at scale with zero human involvement? If yes, the model works and the UGC ladder amplifies it. If no, the thesis breaks.

**Most likely failure mode:** AI content is "fine" but doesn't break through. Products reach $3-15K MRR through moderate organic traction but plateau. Portfolio generates $200-600K ARR. Still sellable for $3-10M.

---

**Build the content engine first. Distribution is everything. The product is second priority. If nobody finds it, it doesn't matter how good it is.**

---

## Part XII: AI SEO Strategy

Google does not penalize AI content. Google penalizes unhelpful content. The March 2024 core update wiped out mass-produced generic AI slop, but well-structured AI content with real substance still ranks. The strategy is specificity and topical authority.

### Tools for Automated SEO

| Tool | Purpose | Cost |
|------|---------|------|
| **SurferSEO / Clearscope** | Analyze top-ranking pages, get exact terms/structure to include. Pair with Claude for writing. | $89-179/mo |
| **Byword / Koala / SEOWriting** | Programmatic article generation at scale for long-tail keywords | $50-100/mo |
| **Ahrefs Lite** | Keyword research, rank tracking, backlink analysis | $99/mo |
| **Google Search Console API** | Free. Submit URLs, check index status, search analytics | Free |

### Programmatic SEO

The real play is programmatic SEO: auto-generating pages targeting specific long-tail queries. Example for BayFlow: "brake pad replacement cost [year] [make] [model]" generates thousands of unique, useful pages that rank for high-intent queries. Each page funnels to the product.

### Parasite SEO (Fast Ranking)

Publish on high-DA platforms where domain authority is already established. These rank in weeks, not the 3-6 months a new domain takes:
- Medium, LinkedIn articles, Quora answers, Reddit posts
- Link back to the main site
- Use these for early traffic while the main domain builds authority

### Topical Authority

30 deep articles about auto repair estimates will outrank 200 shallow posts across random topics. Google rewards sites that demonstrate expertise in a focused area. Every business should own 30-50 keywords in its vertical, not scatter across unrelated topics.

---

## Part XIII: Content Quality Phasing

### The Three Phases

**Phase 1 - AI-Written with Human Standards (Seed, $0-5K MRR):**
Write with Claude using content quality standards (banned words, industry-specific voice, specific numbers and real examples). Add actual data points, specific product models, real prices. This reads as human-written because it has substance, not because it's disguising itself. Cost: ~$20-50/month in API calls.

**Phase 2 - AI + Human Review ($5-15K MRR):**
Hire a Fiverr or Upwork copywriter familiar with the vertical to review AI content and add real anecdotes, local market details, personal stories AI can't fake. ~$50/article for 4-8 articles/month = $200-400/mo. This is about adding authenticity, not removing a penalty.

**Phase 3 - Human-Led, AI-Assisted ($15K+ MRR):**
Hire a part-time content person from the industry (e.g., a former shop owner who can write). They produce 2-4 hero articles/month. AI handles the long-tail programmatic content and social media. This creates genuinely authoritative content that builds backlinks organically.

### Key Insight: No Permanent Penalty

If content quality improves, Google re-indexes and re-ranks. There is no permanent mark. Sites that cleaned up after the helpful content update recovered within 1-2 update cycles (~2-4 months). So starting AI-first and upgrading later is a valid strategy. The risk is only ranking slower initially, not being permanently penalized.

---

## Part XIV: Support-Driven Product Iteration

Support tickets and reviews are the best free product roadmap. The loop:

### The Feedback Loop

1. Customer hits a wall or requests something -> support ticket
2. Haiku auto-resolves common questions (password reset, how-to, billing)
3. Anything Haiku can't handle gets escalated to the human operator
4. Every ticket is tagged: `bug`, `feature-request`, `confusion` (UX problem)
5. Weekly, the Product Agent (or human) reviews tagged tickets and picks what to build
6. Features requested 3+ times get prioritized automatically

### Review Mining

- Monitor G2, Capterra, Google reviews for every product
- "Wish it had X" = free validated feature request from a real customer
- Negative reviews on competitor products = build what they're missing
- Positive reviews = double down on what's working, use quotes in marketing

### The n8n Workflow

Support inbox -> Haiku triage -> auto-resolve OR escalate -> log to `feature_requests` table in Supabase -> weekly digest of top requests surfaces to CEO Agent -> priorities flow into weekly plan.

### Scaling Rule

At seed stage, the human operator handles escalated tickets directly. This is intentional: direct customer contact builds product intuition. At scale ($10K+ MRR), hire a part-time support person from the industry. Haiku still handles 70-80% automatically.

---

## Part XV: Business Launch Velocity

### What Actually Limits Launch Speed

The bottleneck is distribution, not creation. Forking the template, spinning up Supabase + Vercel, writing landing copy is 2-3 hours per business. But:

- SEO takes 3-6 months to rank regardless of publish speed
- Each business needs vertical-specific content (auto repair shops, dentists, and HVAC companies all talk differently)
- Support load scales linearly with customers
- Each product needs domain-specific features (VIN decode for auto shops, treatment codes for dental, etc.)

### Realistic Pace

- Prove one business first (BayFlow to $10K MRR)
- Extract the playbook (what worked for SEO, content, conversion)
- Scale to 3-5 businesses once the playbook is proven
- Then 2-3 new launches per month as automation tightens
- Not 100/month. Each needs enough attention to actually grow.
