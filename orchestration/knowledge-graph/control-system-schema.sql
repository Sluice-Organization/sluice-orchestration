-- ============================================================================
-- The Forge - Centralized Control System Schema
-- Central configuration & context store for CEO Agent decision-making
-- Run in: forge-orchestrator Supabase (wjukfdziomnejtlmegvv)
-- Version: 1.0
-- ============================================================================

-- ============================================================================
-- 1. SYSTEM CONFIG TABLE
--    Central configuration that all workflows read from.
--    The CEO Agent writes here; every other workflow reads.
-- ============================================================================

CREATE TABLE IF NOT EXISTS system_config (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id text NOT NULL,
  config_key text NOT NULL,
  config_value jsonb NOT NULL,
  updated_by text DEFAULT 'system',
  updated_at timestamptz DEFAULT now(),
  UNIQUE(business_id, config_key)
);

CREATE INDEX idx_system_config_business ON system_config (business_id);
CREATE INDEX idx_system_config_key ON system_config (config_key);

-- ============================================================================
-- 2. SYSTEM CONTEXT TABLE
--    Aggregated metrics snapshot. Written by Context Aggregator workflow,
--    read by CEO Agent for decision-making.
-- ============================================================================

CREATE TABLE IF NOT EXISTS system_context (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id text NOT NULL,
  context_key text NOT NULL,
  context_value jsonb NOT NULL,
  updated_at timestamptz DEFAULT now(),
  UNIQUE(business_id, context_key)
);

CREATE INDEX idx_system_context_business ON system_context (business_id);
CREATE INDEX idx_system_context_key ON system_context (context_key);

-- ============================================================================
-- 3. SEED DATA - BayFlow Defaults
-- ============================================================================

INSERT INTO system_config (business_id, config_key, config_value, updated_by) VALUES
  ('bayflow', 'cold_email', '{"daily_limit": 30, "sending_domains": ["trybayflow.com"], "active": false}', 'system'),
  ('bayflow', 'ai_calling', '{"daily_limit": 50, "active": false, "call_hours_start": 10, "call_hours_end": 16}', 'system'),
  ('bayflow', 'google_ads', '{"active": false, "daily_budget": 0, "keywords": []}', 'system'),
  ('bayflow', 'meta_ads', '{"active": false, "daily_budget": 0}', 'system'),
  ('bayflow', 'content', '{"blog_posts_per_week": 2, "reel_scripts_per_week": 2, "active": true}', 'system'),
  ('bayflow', 'lead_gen', '{"regions": ["ohio"], "queries": ["auto repair shop"], "cities_per_batch": 10, "active": true}', 'system'),
  ('bayflow', 'pricing', '{"solo": 29, "pro": 49, "shop": 99, "trial_days": 14}', 'system'),
  ('bayflow', 'support', '{"auto_resolve_enabled": true, "escalation_email": "25shapatel@gmail.com"}', 'system'),
  ('bayflow', 'seo', '{"target_keywords_limit": 20, "gsc_active": false, "ahrefs_active": false}', 'system'),
  ('bayflow', 'notifications', '{"telegram_enabled": true, "email_enabled": true}', 'system'),
  ('_global', 'ceo_authority', '{"can_activate_paid_ads": true, "max_daily_ad_spend": 50, "can_launch_business": true, "can_kill_business": false, "can_adjust_pricing": false, "can_expand_regions": true, "can_scale_email": true, "requires_approval": ["kill_business", "adjust_pricing", "spend_over_100"]}', 'system')
ON CONFLICT (business_id, config_key) DO NOTHING;

-- ============================================================================
-- 4. UPDATED_AT TRIGGERS
--    Uses existing update_updated_at_column() from schema.sql
-- ============================================================================

CREATE TRIGGER trg_system_config_updated_at
  BEFORE UPDATE ON system_config
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_system_context_updated_at
  BEFORE UPDATE ON system_context
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- 5. ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE system_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_context ENABLE ROW LEVEL SECURITY;

-- Service role full access (matches existing pattern)
CREATE POLICY "Service role full access on system_config"
  ON system_config FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on system_context"
  ON system_context FOR ALL
  USING (auth.role() = 'service_role');

-- Anon role: read all config (workflows need to read settings)
CREATE POLICY "Anon can read system_config"
  ON system_config FOR SELECT
  USING (true);

-- Anon role: read and write context (aggregator writes, CEO reads)
CREATE POLICY "Anon can read system_context"
  ON system_context FOR SELECT
  USING (true);

CREATE POLICY "Anon can insert system_context"
  ON system_context FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anon can update system_context"
  ON system_context FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- Anon role: update config (CEO Agent writes config changes)
CREATE POLICY "Anon can update system_config"
  ON system_config FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- ============================================================================
-- 6. HELPER VIEW - Current config for a business (flattened)
-- ============================================================================

CREATE OR REPLACE VIEW v_business_config AS
SELECT
  business_id,
  jsonb_object_agg(config_key, config_value) AS config
FROM system_config
GROUP BY business_id;

CREATE OR REPLACE VIEW v_business_context AS
SELECT
  business_id,
  jsonb_object_agg(context_key, context_value) AS context
FROM system_context
GROUP BY business_id;
