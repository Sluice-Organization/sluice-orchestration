-- ============================================================================
-- Cold Email Outreach Schema
-- Tables for B2B cold email lead management and outreach tracking
-- Run in: forge-orchestrator Supabase (wjukfdziomnejtlmegvv)
-- ============================================================================

-- ============================================================================
-- ENUMS
-- ============================================================================

CREATE TYPE cold_email_status AS ENUM (
  'new',
  'contacted',
  'follow_up_1',
  'follow_up_2',
  'completed',
  'replied',
  'converted',
  'unsubscribed'
);

CREATE TYPE cold_email_sentiment AS ENUM (
  'positive',
  'neutral',
  'negative'
);

CREATE TYPE cold_email_type AS ENUM (
  'initial',
  'follow_up_1',
  'follow_up_2'
);

CREATE TYPE cold_email_task_status AS ENUM (
  'pending',
  'in_progress',
  'completed',
  'dismissed'
);

-- ============================================================================
-- LEADS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS cold_email_leads (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_name   text NOT NULL,
  email           text NOT NULL UNIQUE,
  first_name      text,
  last_name       text,
  phone           text,
  website         text,
  city            text,
  state           text,
  source          text DEFAULT 'google_maps',
  status          cold_email_status DEFAULT 'new',
  last_contacted_at   timestamptz,
  last_email_type     cold_email_type,
  last_resend_id      text,
  replied_at          timestamptz,
  reply_sentiment     cold_email_sentiment,
  converted_at        timestamptz,
  created_at          timestamptz DEFAULT now(),
  updated_at          timestamptz DEFAULT now()
);

-- Index for status-based queries (used by email sender flow)
CREATE INDEX idx_cold_email_leads_status ON cold_email_leads (status);

-- Index for deduplication checks
CREATE INDEX idx_cold_email_leads_email ON cold_email_leads (email);

-- Index for ordering by creation date
CREATE INDEX idx_cold_email_leads_created ON cold_email_leads (created_at);

-- ============================================================================
-- EMAIL LOG TABLE (Knowledge Graph integration)
-- ============================================================================

CREATE TABLE IF NOT EXISTS cold_email_log (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lead_id     uuid REFERENCES cold_email_leads(id) ON DELETE CASCADE,
  email_type  cold_email_type NOT NULL,
  sent        boolean DEFAULT false,
  resend_id   text,
  sent_at     timestamptz DEFAULT now()
);

CREATE INDEX idx_cold_email_log_lead ON cold_email_log (lead_id);

-- ============================================================================
-- TASKS TABLE (for positive reply follow-ups)
-- ============================================================================

CREATE TABLE IF NOT EXISTS cold_email_tasks (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email           text NOT NULL,
  task_type       text DEFAULT 'follow_up_positive_reply',
  subject         text,
  reply_preview   text,
  status          cold_email_task_status DEFAULT 'pending',
  created_at      timestamptz DEFAULT now(),
  completed_at    timestamptz
);

CREATE INDEX idx_cold_email_tasks_status ON cold_email_tasks (status);

-- ============================================================================
-- AUTO-UPDATE updated_at TRIGGER
-- ============================================================================

CREATE OR REPLACE FUNCTION update_cold_email_leads_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_cold_email_leads_updated_at
  BEFORE UPDATE ON cold_email_leads
  FOR EACH ROW
  EXECUTE FUNCTION update_cold_email_leads_updated_at();

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE cold_email_leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE cold_email_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE cold_email_tasks ENABLE ROW LEVEL SECURITY;

-- Service role can do everything
CREATE POLICY "Service role full access on cold_email_leads"
  ON cold_email_leads FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on cold_email_log"
  ON cold_email_log FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on cold_email_tasks"
  ON cold_email_tasks FOR ALL
  USING (auth.role() = 'service_role');

-- Anon role can read leads (for deduplication check) and insert
CREATE POLICY "Anon can read cold_email_leads"
  ON cold_email_leads FOR SELECT
  USING (true);

CREATE POLICY "Anon can insert cold_email_leads"
  ON cold_email_leads FOR INSERT
  WITH CHECK (true);
