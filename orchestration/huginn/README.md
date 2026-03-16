# Huginn Deployment Guide for Forge Discovery Engine

Huginn monitors the web for business opportunity signals and feeds them into the n8n Discovery Engine via webhooks.

## Architecture

```
[Huginn Agents] --POST--> [n8n Webhook] ---> [Discovery Engine Workflow]
                           /webhook/discovery-signal
```

Each monitoring source follows a 2-3 agent chain:
1. **Source Agent** (RssAgent or WebsiteAgent) - fetches and extracts data
2. **Filter Agent** (TriggerAgent, optional) - applies pattern/threshold filters
3. **Post Agent** (PostAgent) - sends matching signals to n8n webhook

## Monitored Sources

| Source | Agent Type | Schedule | Signal Type |
|--------|-----------|----------|-------------|
| Acquire.com ($500K-5M SaaS) | WebsiteAgent | every 6h | acquisition-candidate |
| G2 trending tools | RssAgent | every 12h | market-trend |
| Capterra trending software | WebsiteAgent | every 12h | market-trend |
| IndieHackers revenue dashboards | WebsiteAgent | every 12h | revenue-signal |
| Reddit (r/SaaS, r/smallbusiness, r/Entrepreneur) | RssAgent + TriggerAgent | every 2h | demand-pattern |
| Google Trends (software searches) | WebsiteAgent + TriggerAgent | daily | search-trend |
| Platform changelogs (10 platforms) | RssAgent/WebsiteAgent | every 6-12h | platform-changelog |
| Chrome Web Store (1-2 star) | WebsiteAgent + TriggerAgent | daily | competitor-weakness |
| Shopify App Store (1-2 star) | WebsiteAgent + TriggerAgent | daily | competitor-weakness |

## Deployment on Railway

### Prerequisites
- Railway account (https://railway.app)
- n8n already running at `https://n8n-production-bb4b.up.railway.app`

### Step 1: Create PostgreSQL Database

1. Go to your Railway project dashboard.
2. Click **New** > **Database** > **Add PostgreSQL**.
3. Once provisioned, note the connection variables Railway exposes: `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD`.

### Step 2: Deploy Huginn Service

**Option A: Deploy from Docker image (recommended)**

1. In the same Railway project, click **New** > **Docker Image**.
2. Enter image: `ghcr.io/huginn/huginn:latest`.
3. Set the following environment variables:

```
DATABASE_ADAPTER=postgresql
DATABASE_HOST=${{Postgres.PGHOST}}
DATABASE_PORT=${{Postgres.PGPORT}}
DATABASE_NAME=${{Postgres.PGDATABASE}}
DATABASE_USERNAME=${{Postgres.PGUSER}}
DATABASE_PASSWORD=${{Postgres.PGPASSWORD}}
DOMAIN=${{RAILWAY_PUBLIC_DOMAIN}}
FORCE_SSL=true
PORT=3000
INVITATION_CODE=<choose-a-code>
SEED_USERNAME=admin
SEED_PASSWORD=<choose-a-strong-password>
SECRET_TOKEN=<generate-with: openssl rand -hex 64>
TIMEZONE=America/New_York
```

4. Under **Settings** > **Networking**, click **Generate Domain** to get a public URL.
5. Set the port to `3000`.

**Option B: Deploy from this repo**

1. Push the `orchestration/huginn/` directory to a GitHub repo.
2. In Railway, click **New** > **GitHub Repo** and select it.
3. Railway will detect the `docker-compose.yml` and deploy.
4. Set the same environment variables listed above.

### Step 3: Verify Deployment

1. Visit `https://<your-railway-domain>` in a browser.
2. Log in with the `SEED_USERNAME` / `SEED_PASSWORD` you configured.
3. You should see an empty Huginn dashboard.

### Step 4: Set Up the n8n Webhook Receiver

Before creating Huginn agents, make sure n8n has a workflow to receive signals:

1. In n8n, create a new workflow called **Discovery Signal Receiver**.
2. Add a **Webhook** node:
   - Method: POST
   - Path: `discovery-signal`
   - Authentication: None (add Header Auth later for production)
   - Response Mode: Immediately
3. Add a **Switch** node connected to the webhook, routing on `$json.signal_type`:
   - `saas_listing` -> Acquire.com processing branch
   - `demand_pattern` -> Reddit/demand processing branch
   - `trending_tool` -> Market trend processing branch
   - `rising_search` -> Google Trends processing branch
   - `platform_update` -> Changelog processing branch
   - `low_rated_app` -> Competitor weakness processing branch
   - `revenue_dashboard` -> Revenue signal processing branch
4. Each branch should end with a node that writes the signal to the Knowledge Graph (Supabase).
5. Activate the workflow.

### Step 5: Create Huginn Agents

You have two options:

**Option A: Import from agents-config.json (faster)**

Huginn supports scenario import via its web UI:

1. Log into Huginn.
2. Go to **Scenarios** > **New Scenario**, name it "Forge Discovery Engine".
3. For each agent in `agents-config.json`, go to **Agents** > **New Agent**.
4. Select the agent type, paste the `options` from the JSON, set the schedule, and wire up sources.

There is no bulk-import API in Huginn's UI, so you create agents one at a time. The JSON file serves as your reference for each agent's exact configuration.

**Option B: Use the Huginn API**

```bash
# Get your Huginn auth token
HUGINN_URL="https://<your-railway-domain>"
HUGINN_TOKEN="<your-api-token>"  # Found in Huginn > Account > API Token

# Create an agent via API
curl -X POST "$HUGINN_URL/api/v1/agents" \
  -H "Authorization: Token $HUGINN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "agent": {
      "type": "Agents::RssAgent",
      "name": "Reddit - r/SaaS",
      "schedule": "every_2h",
      "options": {
        "url": "https://www.reddit.com/r/SaaS/new/.rss?limit=50",
        "expected_update_period_in_days": 1,
        "clean": false,
        "headers": { "User-Agent": "Forge-Discovery-Bot/1.0" }
      },
      "keep_events_for": 259200
    }
  }'
```

Repeat for each agent in `agents-config.json`. Wire sources by including `"source_ids": [<id>]` in the POST body (use IDs returned from previous creation calls).

### Step 6: Agent Creation Order

Create agents in this order (sources must exist before agents that depend on them):

1. All source agents first (RssAgent and WebsiteAgent types)
2. All filter agents (TriggerAgent types) -- they reference source agents
3. All Post agents last -- they reference filter or source agents

Specifically:

```
Round 1 (sources):
  - Acquire.com - SaaS Listings Feed
  - G2 - Fastest Growing SMB Tools
  - Capterra - Trending SMB Software
  - IndieHackers - Open Revenue Dashboards
  - Reddit - r/SaaS
  - Reddit - r/smallbusiness
  - Reddit - r/Entrepreneur
  - Google Trends - Industry Software Searches
  - All 10 Changelog agents
  - Chrome Web Store - Low-Rated Extensions
  - Shopify App Store - Low-Rated Apps

Round 2 (filters):
  - Reddit - Pattern Filter
  - Google Trends - Software Filter
  - Chrome Web Store - Low Rating Filter
  - Shopify App Store - Low Rating Filter

Round 3 (webhooks):
  - Acquire.com - Signal to n8n
  - G2 - Signal to n8n
  - Capterra - Signal to n8n
  - IndieHackers - Signal to n8n
  - Reddit - Signal to n8n
  - Google Trends - Signal to n8n
  - Changelogs - Signal to n8n
  - App Store Reviews - Signal to n8n
```

### Step 7: Verify Signal Flow

1. In Huginn, click on any source agent and hit **Run**.
2. Check the agent's **Events** tab -- you should see extracted data.
3. In n8n, check the Discovery Signal Receiver workflow execution log.
4. You should see the signal arrive with the correct `signal_type` and `source`.

## Webhook Payload Format

Every signal POST to n8n follows this structure:

```json
{
  "source": "reddit",
  "signal_type": "demand_pattern",
  "title": "Does anyone know a tool for...",
  "url": "https://reddit.com/r/SaaS/...",
  "detected_at": "2026-03-14T10:30:00Z",
  "...": "source-specific fields"
}
```

Headers included on every request:
- `X-Forge-Source: huginn`
- `X-Signal-Type: <signal-category>`
- `Content-Type: application/json`

## Maintenance

### CSS Selectors

WebsiteAgent selectors (Acquire.com, Capterra, IndieHackers, Chrome Web Store, Shopify App Store, Notion, Figma) will break when those sites update their HTML. When an agent stops producing events:

1. Visit the target URL in a browser.
2. Inspect the page to find updated CSS selectors.
3. Update the agent's `extract` options in Huginn.

### Rate Limiting

- Reddit: respect their rate limits. The RSS feed at 2h intervals is safe.
- Google Trends: daily checks are sufficient; more frequent may get blocked.
- Chrome Web Store / Shopify: daily scrapes should stay under any soft limits.

### Scaling

Huginn runs a single delayed_job worker by default. If event processing falls behind:

1. In Railway, increase the service RAM.
2. Set `HUGINN_SCHEDULER_FREQUENCY=0.3` for faster job polling.
3. Consider running a second Huginn instance with `WORKER_ONLY=true`.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Agent shows "No events" after run | Check the URL manually. Verify CSS/XPath selectors. |
| PostAgent returns 404 | Verify n8n webhook workflow is active and path is `discovery-signal`. |
| PostAgent returns 500 | Check n8n execution logs for errors in the receiver workflow. |
| Agent stuck in "working" | Restart the Huginn service in Railway. Check delayed_job logs. |
| Database connection error | Verify Railway PostgreSQL plugin is running. Check env var references. |
