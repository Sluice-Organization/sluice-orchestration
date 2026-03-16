-- ============================================================================
-- The Forge - Knowledge Graph Schema
-- Cross-portfolio intelligence store for all businesses
-- Version: 1.0
-- ============================================================================

-- ============================================================================
-- ENUMS
-- ============================================================================

CREATE TYPE business_type_enum AS ENUM (
  'smb_vertical_tool',
  'prosumer_workflow_tool',
  'plg_platform'
);

CREATE TYPE business_status_enum AS ENUM (
  'seed',
  'traction',
  'scale',
  'breakout',
  'killed',
  'sold'
);

CREATE TYPE content_type_enum AS ENUM (
  'blog_post',
  'reel',
  'email',
  'landing_page',
  'free_tool',
  'ad_creative'
);

CREATE TYPE ad_platform_enum AS ENUM (
  'google_ads',
  'meta_ads',
  'tiktok_ads'
);

CREATE TYPE ad_creative_type_enum AS ENUM (
  'text',
  'image',
  'video',
  'ugc'
);

CREATE TYPE opportunity_source_enum AS ENUM (
  'tier1_clone',
  'tier2_smb',
  'tier3_platform',
  'tier4_keyword',
  'tier5_support'
);

CREATE TYPE competition_level_enum AS ENUM (
  'low',
  'medium',
  'high'
);

CREATE TYPE opportunity_status_enum AS ENUM (
  'raw',
  'scored',
  'approved',
  'rejected',
  'launched'
);

CREATE TYPE opportunity_potential_enum AS ENUM (
  'feature_request',
  'business_opportunity'
);

CREATE TYPE budget_stage_enum AS ENUM (
  'seed',
  'traction',
  'scale',
  'breakout'
);

-- ============================================================================
-- 1. BUSINESSES
-- ============================================================================

CREATE TABLE businesses (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id   text NOT NULL UNIQUE,
  name          text NOT NULL,
  description   text,
  business_type business_type_enum NOT NULL,
  category      text NOT NULL,
  status        business_status_enum NOT NULL DEFAULT 'seed',
  launched_at   timestamptz,
  killed_at     timestamptz,
  sold_at       timestamptz,
  sale_price    decimal,
  total_capital_deployed decimal NOT NULL DEFAULT 0,
  total_revenue decimal NOT NULL DEFAULT 0,
  current_mrr   decimal NOT NULL DEFAULT 0,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_businesses_status ON businesses (status);
CREATE INDEX idx_businesses_category ON businesses (category);
CREATE INDEX idx_businesses_business_type ON businesses (business_type);

-- ============================================================================
-- 2. POST MORTEMS
-- ============================================================================

CREATE TABLE post_mortems (
  id                          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id                 uuid NOT NULL REFERENCES businesses (id) ON DELETE CASCADE,
  hypothesis                  text NOT NULL,
  target_market               text NOT NULL,
  what_was_built              text NOT NULL,
  distribution_channels       jsonb NOT NULL DEFAULT '[]'::jsonb,
  timeline_weeks              jsonb NOT NULL DEFAULT '[]'::jsonb,
  total_capital_deployed      decimal NOT NULL DEFAULT 0,
  total_revenue_recovered     decimal NOT NULL DEFAULT 0,
  top_performing_assets       jsonb DEFAULT '[]'::jsonb,
  worst_performing_assets     jsonb DEFAULT '[]'::jsonb,
  cac_trajectory              jsonb DEFAULT '[]'::jsonb,
  cause_of_death              text NOT NULL,
  what_agent_would_do_differently text NOT NULL,
  suggested_adjacent_opportunities jsonb DEFAULT '[]'::jsonb,
  general_notes               text,
  lifetime_days               integer NOT NULL,
  created_at                  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_post_mortems_business_id ON post_mortems (business_id);

-- ============================================================================
-- 3. DAILY METRICS
-- ============================================================================

CREATE TABLE daily_metrics (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id         uuid NOT NULL REFERENCES businesses (id) ON DELETE CASCADE,
  date                date NOT NULL,
  mrr                 decimal NOT NULL DEFAULT 0,
  revenue_organic     decimal NOT NULL DEFAULT 0,
  revenue_paid        decimal NOT NULL DEFAULT 0,
  revenue_direct      decimal NOT NULL DEFAULT 0,
  revenue_referral    decimal NOT NULL DEFAULT 0,
  traffic_total       integer NOT NULL DEFAULT 0,
  traffic_organic     integer NOT NULL DEFAULT 0,
  traffic_paid        integer NOT NULL DEFAULT 0,
  traffic_direct      integer NOT NULL DEFAULT 0,
  traffic_referral    integer NOT NULL DEFAULT 0,
  signups             integer NOT NULL DEFAULT 0,
  trials              integer NOT NULL DEFAULT 0,
  conversions         integer NOT NULL DEFAULT 0,
  churn_count         integer NOT NULL DEFAULT 0,
  churn_mrr           decimal NOT NULL DEFAULT 0,
  support_tickets     integer NOT NULL DEFAULT 0,
  support_auto_resolved integer NOT NULL DEFAULT 0,
  ad_spend            decimal NOT NULL DEFAULT 0,
  ai_api_cost         decimal NOT NULL DEFAULT 0,
  UNIQUE (business_id, date)
);

CREATE INDEX idx_daily_metrics_business_id ON daily_metrics (business_id);
CREATE INDEX idx_daily_metrics_date ON daily_metrics (date);
CREATE INDEX idx_daily_metrics_biz_date ON daily_metrics (business_id, date DESC);

-- ============================================================================
-- 4. CONTENT PERFORMANCE
-- ============================================================================

CREATE TABLE content_performance (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id         uuid NOT NULL REFERENCES businesses (id) ON DELETE CASCADE,
  content_type        content_type_enum NOT NULL,
  title               text NOT NULL,
  url                 text,
  published_at        timestamptz,
  impressions         integer NOT NULL DEFAULT 0,
  clicks              integer NOT NULL DEFAULT 0,
  signups_attributed  integer NOT NULL DEFAULT 0,
  revenue_attributed  decimal NOT NULL DEFAULT 0,
  keyword_target      text,
  keyword_position    integer,
  reel_format         text,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_content_performance_business_id ON content_performance (business_id);
CREATE INDEX idx_content_performance_type ON content_performance (content_type);
CREATE INDEX idx_content_performance_published ON content_performance (published_at DESC);

-- ============================================================================
-- 5. KEYWORD PERFORMANCE
-- ============================================================================

CREATE TABLE keyword_performance (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id         uuid NOT NULL REFERENCES businesses (id) ON DELETE CASCADE,
  keyword             text NOT NULL,
  search_volume       integer NOT NULL DEFAULT 0,
  keyword_difficulty  integer NOT NULL DEFAULT 0,
  current_position    integer,
  clicks_last_30d     integer NOT NULL DEFAULT 0,
  impressions_last_30d integer NOT NULL DEFAULT 0,
  signups_attributed  integer NOT NULL DEFAULT 0,
  tracked_since       date NOT NULL DEFAULT CURRENT_DATE,
  last_updated        timestamptz NOT NULL DEFAULT now(),
  UNIQUE (business_id, keyword)
);

CREATE INDEX idx_keyword_performance_business_id ON keyword_performance (business_id);
CREATE INDEX idx_keyword_performance_keyword ON keyword_performance (keyword);
CREATE INDEX idx_keyword_performance_volume ON keyword_performance (search_volume DESC);

-- ============================================================================
-- 6. AD PERFORMANCE
-- ============================================================================

CREATE TABLE ad_performance (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id     uuid NOT NULL REFERENCES businesses (id) ON DELETE CASCADE,
  platform        ad_platform_enum NOT NULL,
  campaign_name   text NOT NULL,
  creative_type   ad_creative_type_enum NOT NULL,
  impressions     integer NOT NULL DEFAULT 0,
  clicks          integer NOT NULL DEFAULT 0,
  conversions     integer NOT NULL DEFAULT 0,
  spend           decimal NOT NULL DEFAULT 0,
  revenue         decimal NOT NULL DEFAULT 0,
  roas            decimal GENERATED ALWAYS AS (
                    CASE WHEN spend > 0 THEN revenue / spend ELSE NULL END
                  ) STORED,
  date            date NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_ad_performance_business_id ON ad_performance (business_id);
CREATE INDEX idx_ad_performance_date ON ad_performance (date);
CREATE INDEX idx_ad_performance_platform ON ad_performance (platform);

-- ============================================================================
-- 7. OPPORTUNITIES (Discovery Engine Pipeline)
-- ============================================================================

CREATE TABLE opportunities (
  id                      uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_tier             opportunity_source_enum NOT NULL,
  source_url              text,
  category                text NOT NULL,
  description             text NOT NULL,
  estimated_keyword_volume integer,
  competition_level       competition_level_enum,
  reel_potential_score    integer CHECK (reel_potential_score BETWEEN 1 AND 10),
  ai_score                decimal CHECK (ai_score BETWEEN 0 AND 10),
  ai_scoring_notes        text,
  status                  opportunity_status_enum NOT NULL DEFAULT 'raw',
  approved_at             timestamptz,
  launched_business_id    uuid REFERENCES businesses (id) ON DELETE SET NULL,
  raw_data                jsonb DEFAULT '{}'::jsonb,
  created_at              timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_opportunities_status ON opportunities (status);
CREATE INDEX idx_opportunities_source_tier ON opportunities (source_tier);
CREATE INDEX idx_opportunities_category ON opportunities (category);
CREATE INDEX idx_opportunities_ai_score ON opportunities (ai_score DESC NULLS LAST);

-- ============================================================================
-- 8. SUPPORT THEMES (Cross-Portfolio Intelligence)
-- ============================================================================

CREATE TABLE support_themes (
  id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id           uuid NOT NULL REFERENCES businesses (id) ON DELETE CASCADE,
  theme                 text NOT NULL,
  mention_count         integer NOT NULL DEFAULT 1,
  sample_tickets        jsonb NOT NULL DEFAULT '[]'::jsonb,
  opportunity_potential opportunity_potential_enum,
  flagged_for_review    boolean NOT NULL DEFAULT false,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_support_themes_business_id ON support_themes (business_id);
CREATE INDEX idx_support_themes_flagged ON support_themes (flagged_for_review) WHERE flagged_for_review = true;
CREATE INDEX idx_support_themes_mention_count ON support_themes (mention_count DESC);

-- ============================================================================
-- 9. BUDGET TRACKING
-- ============================================================================

CREATE TABLE budget_tracking (
  id                      uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id             uuid NOT NULL REFERENCES businesses (id) ON DELETE CASCADE,
  date                    date NOT NULL,
  stage                   budget_stage_enum NOT NULL,
  daily_budget_limit      decimal NOT NULL,
  content_seo_spend       decimal NOT NULL DEFAULT 0,
  paid_ads_spend          decimal NOT NULL DEFAULT 0,
  product_spend           decimal NOT NULL DEFAULT 0,
  ai_api_spend            decimal NOT NULL DEFAULT 0,
  total_spend             decimal NOT NULL DEFAULT 0,
  revenue                 decimal NOT NULL DEFAULT 0,
  balance                 decimal NOT NULL DEFAULT 0,
  circuit_breaker_triggered boolean NOT NULL DEFAULT false,
  circuit_breaker_reason  text,
  UNIQUE (business_id, date)
);

CREATE INDEX idx_budget_tracking_business_id ON budget_tracking (business_id);
CREATE INDEX idx_budget_tracking_date ON budget_tracking (date);
CREATE INDEX idx_budget_tracking_circuit ON budget_tracking (circuit_breaker_triggered)
  WHERE circuit_breaker_triggered = true;

-- ============================================================================
-- UPDATED_AT TRIGGER
-- ============================================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_businesses_updated_at
  BEFORE UPDATE ON businesses
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_content_performance_updated_at
  BEFORE UPDATE ON content_performance
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_support_themes_updated_at
  BEFORE UPDATE ON support_themes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_mortems ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_performance ENABLE ROW LEVEL SECURITY;
ALTER TABLE keyword_performance ENABLE ROW LEVEL SECURITY;
ALTER TABLE ad_performance ENABLE ROW LEVEL SECURITY;
ALTER TABLE opportunities ENABLE ROW LEVEL SECURITY;
ALTER TABLE support_themes ENABLE ROW LEVEL SECURITY;
ALTER TABLE budget_tracking ENABLE ROW LEVEL SECURITY;

-- Service role gets full access to all tables
CREATE POLICY "Service role full access on businesses"
  ON businesses FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Service role full access on post_mortems"
  ON post_mortems FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Service role full access on daily_metrics"
  ON daily_metrics FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Service role full access on content_performance"
  ON content_performance FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Service role full access on keyword_performance"
  ON keyword_performance FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Service role full access on ad_performance"
  ON ad_performance FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Service role full access on opportunities"
  ON opportunities FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Service role full access on support_themes"
  ON support_themes FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Service role full access on budget_tracking"
  ON budget_tracking FOR ALL USING (true) WITH CHECK (true);

-- ============================================================================
-- VIEWS
-- ============================================================================

-- v_business_summary: latest metrics per business
CREATE OR REPLACE VIEW v_business_summary AS
SELECT
  b.id,
  b.business_id,
  b.name,
  b.status,
  b.business_type,
  b.category,
  b.current_mrr,
  b.total_revenue,
  b.total_capital_deployed,
  b.launched_at,
  dm.date AS latest_metrics_date,
  dm.mrr AS latest_mrr,
  dm.traffic_total AS latest_traffic,
  dm.signups AS latest_signups,
  dm.conversions AS latest_conversions,
  dm.churn_count AS latest_churn,
  dm.ad_spend AS latest_ad_spend,
  dm.ai_api_cost AS latest_ai_cost,
  CASE WHEN b.total_capital_deployed > 0
    THEN b.total_revenue / b.total_capital_deployed
    ELSE NULL
  END AS roi,
  CASE WHEN dm.conversions > 0 AND dm.ad_spend > 0
    THEN dm.ad_spend / dm.conversions
    ELSE NULL
  END AS latest_cac
FROM businesses b
LEFT JOIN LATERAL (
  SELECT *
  FROM daily_metrics d
  WHERE d.business_id = b.id
  ORDER BY d.date DESC
  LIMIT 1
) dm ON true;

-- v_category_performance: aggregate performance by business category
CREATE OR REPLACE VIEW v_category_performance AS
SELECT
  b.category,
  b.business_type,
  count(DISTINCT b.id) AS business_count,
  count(DISTINCT b.id) FILTER (WHERE b.status NOT IN ('killed', 'sold')) AS active_count,
  count(DISTINCT b.id) FILTER (WHERE b.status = 'killed') AS killed_count,
  sum(b.total_revenue) AS total_revenue,
  sum(b.total_capital_deployed) AS total_capital,
  avg(b.current_mrr) AS avg_mrr,
  CASE WHEN sum(b.total_capital_deployed) > 0
    THEN sum(b.total_revenue) / sum(b.total_capital_deployed)
    ELSE NULL
  END AS category_roi
FROM businesses b
GROUP BY b.category, b.business_type;

-- v_content_winners: top performing content across portfolio
CREATE OR REPLACE VIEW v_content_winners AS
SELECT
  cp.id,
  b.business_id,
  b.name AS business_name,
  b.category,
  cp.content_type,
  cp.title,
  cp.url,
  cp.published_at,
  cp.impressions,
  cp.clicks,
  cp.signups_attributed,
  cp.revenue_attributed,
  cp.keyword_target,
  cp.keyword_position,
  cp.reel_format,
  CASE WHEN cp.impressions > 0
    THEN round((cp.clicks::decimal / cp.impressions) * 100, 2)
    ELSE 0
  END AS ctr_pct,
  CASE WHEN cp.clicks > 0
    THEN round((cp.signups_attributed::decimal / cp.clicks) * 100, 2)
    ELSE 0
  END AS signup_rate_pct
FROM content_performance cp
JOIN businesses b ON b.id = cp.business_id
WHERE cp.signups_attributed > 0 OR cp.revenue_attributed > 0
ORDER BY cp.revenue_attributed DESC, cp.signups_attributed DESC;

-- v_keyword_opportunities: high-volume, low-difficulty unranked keywords
CREATE OR REPLACE VIEW v_keyword_opportunities AS
SELECT
  kp.id,
  b.business_id,
  b.name AS business_name,
  b.category,
  kp.keyword,
  kp.search_volume,
  kp.keyword_difficulty,
  kp.current_position,
  kp.clicks_last_30d,
  kp.impressions_last_30d,
  kp.tracked_since,
  kp.last_updated
FROM keyword_performance kp
JOIN businesses b ON b.id = kp.business_id
WHERE (kp.current_position IS NULL OR kp.current_position > 20)
  AND kp.keyword_difficulty < 40
  AND kp.search_volume >= 100
ORDER BY kp.search_volume DESC, kp.keyword_difficulty ASC;

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Get trailing N days of metrics for a business
CREATE OR REPLACE FUNCTION get_trailing_metrics(
  p_business_id uuid,
  p_days integer DEFAULT 30
)
RETURNS SETOF daily_metrics
LANGUAGE sql STABLE
AS $$
  SELECT *
  FROM daily_metrics
  WHERE business_id = p_business_id
    AND date >= CURRENT_DATE - p_days
  ORDER BY date DESC;
$$;

-- Calculate burn rate for a business over trailing N days
CREATE OR REPLACE FUNCTION get_burn_rate(
  p_business_id uuid,
  p_days integer DEFAULT 30
)
RETURNS TABLE (
  avg_daily_spend decimal,
  avg_daily_revenue decimal,
  net_burn_per_day decimal,
  days_measured integer
)
LANGUAGE sql STABLE
AS $$
  SELECT
    coalesce(avg(bt.total_spend), 0) AS avg_daily_spend,
    coalesce(avg(bt.revenue), 0) AS avg_daily_revenue,
    coalesce(avg(bt.total_spend - bt.revenue), 0) AS net_burn_per_day,
    count(*)::integer AS days_measured
  FROM budget_tracking bt
  WHERE bt.business_id = p_business_id
    AND bt.date >= CURRENT_DATE - p_days;
$$;
