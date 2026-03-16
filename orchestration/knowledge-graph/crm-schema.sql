-- ============================================================================
-- CRM Extension Schema - Missing Tables & Columns
-- Adds columns/tables referenced by existing workflows but not yet created
-- Run in: forge-orchestrator Supabase (wjukfdziomnejtlmegvv)
-- ============================================================================

-- ============================================================================
-- 1. ADD COLUMNS TO cold_email_leads
--    Referenced by: AI Voice Caller, Email Verification, DNC Check workflows
-- ============================================================================

ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS demo_date timestamptz;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS call_status text;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS call_attempts integer DEFAULT 0;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS retell_call_id text;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS call_outcome text;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS call_transcript text;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS next_call_date timestamptz;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS email_verified boolean DEFAULT false;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS email_verify_result text;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS phone_type text;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS dnc_checked boolean DEFAULT false;
ALTER TABLE cold_email_leads ADD COLUMN IF NOT EXISTS unsubscribed_at timestamptz;

-- ============================================================================
-- 2. voice_call_log TABLE
--    Referenced by: AI Voice Caller workflow
-- ============================================================================

CREATE TABLE IF NOT EXISTS voice_call_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lead_id uuid REFERENCES cold_email_leads(id) ON DELETE SET NULL,
  retell_call_id text,
  phone text,
  direction text DEFAULT 'outbound',
  duration_seconds integer,
  outcome text,
  transcript text,
  sentiment text,
  booking_made boolean DEFAULT false,
  voicemail_left boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX idx_voice_call_log_lead ON voice_call_log(lead_id);
CREATE INDEX idx_voice_call_log_retell ON voice_call_log(retell_call_id);

-- ============================================================================
-- 3. drip_queue TABLE
--    Referenced by: Email Onboarding workflow
-- ============================================================================

CREATE TABLE IF NOT EXISTS drip_queue (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL,
  name text,
  business_id text DEFAULT 'bayflow',
  plan text DEFAULT 'starter',
  signup_date timestamptz DEFAULT now(),
  welcome_email_sent boolean DEFAULT false,
  welcome_email_id text,
  drip_emails_sent jsonb DEFAULT '[]'::jsonb,
  status text DEFAULT 'active',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX idx_drip_queue_status ON drip_queue(status);
CREATE INDEX idx_drip_queue_email ON drip_queue(email);

-- ============================================================================
-- 4. activities TABLE
--    General activity timeline for CRM
-- ============================================================================

CREATE TABLE IF NOT EXISTS activities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lead_id uuid REFERENCES cold_email_leads(id) ON DELETE CASCADE,
  business_id text,
  activity_type text NOT NULL, -- email_sent, call_made, call_received, reply_received, demo_booked, demo_completed, signed_up, payment_received, support_ticket, churned
  channel text, -- email, phone, web, manual
  details jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX idx_activities_lead ON activities(lead_id);
CREATE INDEX idx_activities_type ON activities(activity_type);
CREATE INDEX idx_activities_created ON activities(created_at DESC);

-- ============================================================================
-- 5. ROW LEVEL SECURITY
--    Matches existing pattern from cold-email-schema.sql
-- ============================================================================

ALTER TABLE voice_call_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE drip_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;

-- Service role full access (matches existing pattern)
CREATE POLICY "Service role full access on voice_call_log"
  ON voice_call_log FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on drip_queue"
  ON drip_queue FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on activities"
  ON activities FOR ALL
  USING (auth.role() = 'service_role');

-- Anon read access (for workflow queries via anon key)
CREATE POLICY "Anon can read voice_call_log"
  ON voice_call_log FOR SELECT
  USING (true);

CREATE POLICY "Anon can insert voice_call_log"
  ON voice_call_log FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anon can read drip_queue"
  ON drip_queue FOR SELECT
  USING (true);

CREATE POLICY "Anon can insert drip_queue"
  ON drip_queue FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anon can read activities"
  ON activities FOR SELECT
  USING (true);

CREATE POLICY "Anon can insert activities"
  ON activities FOR INSERT
  WITH CHECK (true);

-- ============================================================================
-- 6. TRIGGERS
--    Uses existing update_updated_at_column() from schema.sql
-- ============================================================================

CREATE TRIGGER trg_drip_queue_updated_at
  BEFORE UPDATE ON drip_queue
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
