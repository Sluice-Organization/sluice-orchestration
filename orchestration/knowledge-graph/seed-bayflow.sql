-- ============================================================================
-- Seed Data: BayFlow (First Business)
-- Run AFTER schema.sql
-- ============================================================================

-- Insert BayFlow as the first business
INSERT INTO businesses (
  business_id,
  name,
  description,
  business_type,
  category,
  status,
  launched_at,
  total_capital_deployed,
  total_revenue,
  current_mrr
) VALUES (
  'bayflow',
  'BayFlow',
  'Auto repair shop management software with scheduling, digital inspections, invoicing, and customer management. Glassmorphic UI design.',
  'smb_vertical_tool',
  'auto_repair_scheduling',
  'seed',
  NULL,  -- not yet launched publicly
  0,
  0,
  0
);

-- Seed initial keyword targets for BayFlow
INSERT INTO keyword_performance (business_id, keyword, search_volume, keyword_difficulty)
SELECT
  b.id,
  kw.keyword,
  kw.search_volume,
  kw.keyword_difficulty
FROM businesses b
CROSS JOIN (VALUES
  ('auto repair shop software',           2400, 35),
  ('auto repair scheduling software',     1300, 28),
  ('mechanic shop management software',   1000, 32),
  ('auto repair invoice software',         880, 25),
  ('digital vehicle inspection app',       720, 22),
  ('auto repair crm',                      590, 30),
  ('repair order management software',     480, 18),
  ('auto shop pos system',                 390, 38),
  ('automotive repair shop management',    320, 27),
  ('auto repair estimate software',        260, 24)
) AS kw(keyword, search_volume, keyword_difficulty)
WHERE b.business_id = 'bayflow';

-- Seed published blog content
INSERT INTO content_performance (business_id, content_type, title, published_at)
SELECT
  b.id,
  'blog_post'::content_type_enum,
  post.title,
  post.published_at
FROM businesses b
CROSS JOIN (VALUES
  ('5 Signs Your Auto Repair Shop Needs Better Software',                '2026-03-01'::timestamptz),
  ('How Digital Vehicle Inspections Increase Customer Trust',            '2026-03-03'::timestamptz),
  ('The True Cost of No-Shows: Why Auto Shops Need Online Scheduling',   '2026-03-05'::timestamptz),
  ('From Paper to Digital: Modernizing Your Repair Order Workflow',      '2026-03-08'::timestamptz),
  ('Auto Repair Shop KPIs: 7 Metrics You Should Track Daily',           '2026-03-10'::timestamptz)
) AS post(title, published_at)
WHERE b.business_id = 'bayflow';

-- Seed the BayFlow opportunity that led to its creation
INSERT INTO opportunities (
  source_tier,
  source_url,
  category,
  description,
  estimated_keyword_volume,
  competition_level,
  reel_potential_score,
  ai_score,
  ai_scoring_notes,
  status,
  approved_at,
  launched_business_id
)
SELECT
  'tier2_smb',
  NULL,
  'auto_repair_scheduling',
  'Auto repair shop management SaaS targeting independent shops. Large fragmented market with 100K+ potential customers. Existing competitors are dated and overpriced.',
  8340,
  'medium',
  7,
  8.2,
  'Large TAM, fragmented market, low tech adoption among independents. Strong SEO opportunity with moderate keyword difficulty. Reel potential from dramatic before/after shop workflows.',
  'launched',
  now(),
  b.id
FROM businesses b
WHERE b.business_id = 'bayflow';

-- Seed initial budget tracking entry (seed stage)
INSERT INTO budget_tracking (
  business_id,
  date,
  stage,
  daily_budget_limit,
  content_seo_spend,
  paid_ads_spend,
  product_spend,
  ai_api_spend,
  total_spend,
  revenue,
  balance
)
SELECT
  b.id,
  CURRENT_DATE,
  'seed',
  50.00,    -- seed stage daily budget
  0,
  0,        -- no paid ads at seed
  0,
  0,
  0,
  0,
  0
FROM businesses b
WHERE b.business_id = 'bayflow';
