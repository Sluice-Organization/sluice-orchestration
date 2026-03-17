-- ============================================================================
-- Pipeline Schema - CRM Pipeline Stages & Sales Sequence Tracking
-- Adds columns to cold_email_leads for multi-channel sequence coordination
-- Run in: forge-orchestrator Supabase (wjukfdziomnejtlmegvv)
-- ============================================================================

-- ============================================================================
-- 1. SALES SEQUENCE TRACKING COLUMNS
--    Used by: Sales Sequence Engine workflow
-- ============================================================================

ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS touch_count integer DEFAULT 0;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS sequence_stage text DEFAULT 'prospect';
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS last_touch_channel text;

-- ============================================================================
-- 2. DEMO TRACKING COLUMNS
--    Used by: Telegram two-way commands, Cal.com booking handler
-- ============================================================================

ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS demo_completed_at timestamptz;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS demo_notes text;

-- ============================================================================
-- 3. TRIAL & CONVERSION TRACKING COLUMNS
--    Used by: Sales Sequence Engine, Stripe Revenue Tracker, Telegram commands
-- ============================================================================

ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS trial_started_at timestamptz;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS conversion_date timestamptz;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS conversion_revenue decimal;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS attributed_channel text;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS attributed_touch_number integer;

-- ============================================================================
-- 4. PIPELINE STAGE ENUM
--    Stages: prospect -> contacted -> engaged -> demo_booked ->
--            demo_completed -> trial_started -> paying -> churned
--
--    NOTE: sequence_stage column uses TEXT type (not enum) for flexibility.
--    Valid values enforced at application level:
--      prospect, contacted, engaged, demo_booked, demo_completed,
--      trial_started, paying, churned, completed
-- ============================================================================

-- ============================================================================
-- 5. INDEX FOR SEQUENCE QUERIES
--    The Sales Sequence Engine queries by sequence_stage and touch_count
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_cold_email_leads_sequence_stage
  ON cold_email_leads (sequence_stage);

CREATE INDEX IF NOT EXISTS idx_cold_email_leads_touch_count
  ON cold_email_leads (touch_count);

CREATE INDEX IF NOT EXISTS idx_cold_email_leads_last_touch_channel
  ON cold_email_leads (last_touch_channel);

-- Composite index for the main sequence query pattern
CREATE INDEX IF NOT EXISTS idx_cold_email_leads_sequence_active
  ON cold_email_leads (status, sequence_stage, last_contacted_at)
  WHERE status NOT IN ('converted', 'unsubscribed', 'rejected', 'completed', 'paying', 'churned');

-- ============================================================================
-- 6. PIPELINE SUMMARY VIEW
--    Quick counts by pipeline stage for Telegram "status" command
-- ============================================================================

CREATE OR REPLACE VIEW v_pipeline_summary AS
SELECT
  sequence_stage,
  count(*) AS lead_count,
  count(*) FILTER (WHERE last_touch_channel = 'email') AS via_email,
  count(*) FILTER (WHERE last_touch_channel = 'call') AS via_call,
  round(avg(touch_count), 1) AS avg_touches,
  max(last_contacted_at) AS last_activity
FROM cold_email_leads
GROUP BY sequence_stage
ORDER BY
  CASE sequence_stage
    WHEN 'prospect' THEN 1
    WHEN 'contacted' THEN 2
    WHEN 'engaged' THEN 3
    WHEN 'demo_booked' THEN 4
    WHEN 'demo_completed' THEN 5
    WHEN 'trial_started' THEN 6
    WHEN 'paying' THEN 7
    WHEN 'churned' THEN 8
    WHEN 'completed' THEN 9
    ELSE 10
  END;

-- ============================================================================
-- 7. CONVERSION ATTRIBUTION VIEW
--    Which channel/touch converts best
-- ============================================================================

CREATE OR REPLACE VIEW v_conversion_attribution AS
SELECT
  attributed_channel,
  attributed_touch_number,
  count(*) AS conversions,
  sum(conversion_revenue) AS total_revenue,
  round(avg(conversion_revenue), 2) AS avg_revenue
FROM cold_email_leads
WHERE conversion_date IS NOT NULL
GROUP BY attributed_channel, attributed_touch_number
ORDER BY conversions DESC;