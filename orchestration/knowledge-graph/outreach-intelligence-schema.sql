-- ============================================================================
-- Outreach Intelligence Schema
-- Learning loop for all outreach: email, calls, social, ads
-- Every piece of outreach is tagged, tracked, and learned from
-- ============================================================================

CREATE TABLE IF NOT EXISTS outreach_intelligence (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id text NOT NULL,

  -- Channel & type
  channel text NOT NULL, -- email, call, reddit, facebook, tiktok, ad
  outreach_type text NOT NULL, -- cold_initial, follow_up_1, follow_up_2, breakup, cold_call, voicemail_drop, reddit_comment, reddit_post

  -- Audience targeting
  audience_type text NOT NULL, -- auto_repair, salon, law_firm, yoga_studio, etc.
  audience_size text, -- solo, small_team, mid_size

  -- Content strategy tags
  tone text, -- casual, professional, urgent, friendly, authoritative, empathetic
  angle text, -- pain_point, social_proof, roi, urgency, curiosity, personal_story, competitor_weakness, free_value
  intent text, -- book_demo, get_reply, build_awareness, get_signup, get_review
  hook_type text, -- question, statistic, pain_point, compliment, mutual_connection, industry_insight

  -- Content
  subject_line text, -- for emails
  content_preview text, -- first 200 chars
  content_full text, -- full content (for learning)
  content_hash text, -- detect similar content

  -- Personalization tracking
  personalization_elements jsonb DEFAULT '{}', -- {name: true, city: true, business_name: true, competitor: true, specific_pain: true, industry_stat: true}
  personalization_depth integer DEFAULT 0, -- 0=generic, 1=name only, 2=name+city, 3=deep (business-specific details)

  -- Timing
  sent_at timestamptz DEFAULT now(),
  day_of_week integer, -- 0=Sunday, 6=Saturday
  hour_of_day integer, -- 0-23

  -- Outcome tracking
  outcome text DEFAULT 'pending', -- pending, no_response, opened, replied_positive, replied_negative, replied_neutral, booked_demo, converted, unsubscribed, bounced
  outcome_at timestamptz,
  response_time_hours decimal,

  -- For emails specifically
  opened boolean DEFAULT false,
  opened_at timestamptz,
  clicked boolean DEFAULT false,
  clicked_at timestamptz,

  -- For calls specifically
  call_duration_seconds integer,
  call_connected boolean DEFAULT false,
  voicemail_left boolean DEFAULT false,

  -- Freeform notes (LLM reads these for context)
  notes text, -- "Shop owner mentioned switching from Mitchell 1, frustrated with pricing"
  what_worked text, -- "Mentioning digital inspections got immediate interest"
  what_didnt_work text, -- "ROI angle fell flat, they care more about time savings"
  learnings text, -- "Auto repair shops in rural areas respond better to casual tone"

  -- Reference back to lead
  lead_id uuid,
  lead_email text,

  -- Meta
  metadata jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now()
);

-- Indexes for the learning queries
CREATE INDEX idx_outreach_channel ON outreach_intelligence (channel);
CREATE INDEX idx_outreach_audience ON outreach_intelligence (audience_type);
CREATE INDEX idx_outreach_outcome ON outreach_intelligence (outcome);
CREATE INDEX idx_outreach_business ON outreach_intelligence (business_id);
CREATE INDEX idx_outreach_tone_angle ON outreach_intelligence (tone, angle);
CREATE INDEX idx_outreach_sent ON outreach_intelligence (sent_at DESC);

-- Composite index for the main learning query
CREATE INDEX idx_outreach_learning ON outreach_intelligence (audience_type, channel, intent, outcome);

-- RLS
ALTER TABLE outreach_intelligence ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Service role full access on outreach_intelligence"
  ON outreach_intelligence FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Anon can read outreach_intelligence"
  ON outreach_intelligence FOR SELECT
  USING (true);

CREATE POLICY "Anon can insert outreach_intelligence"
  ON outreach_intelligence FOR INSERT
  WITH CHECK (true);

-- ============================================================================
-- Learning query views
-- ============================================================================

-- What works best by audience + channel
CREATE OR REPLACE VIEW v_outreach_performance AS
SELECT
  audience_type,
  channel,
  intent,
  tone,
  angle,
  hook_type,
  personalization_depth,
  count(*) AS total_sent,
  count(*) FILTER (WHERE outcome = 'replied_positive' OR outcome = 'booked_demo' OR outcome = 'converted') AS positive_outcomes,
  count(*) FILTER (WHERE outcome = 'replied_positive') AS positive_replies,
  count(*) FILTER (WHERE outcome = 'booked_demo') AS demos_booked,
  count(*) FILTER (WHERE outcome = 'converted') AS conversions,
  count(*) FILTER (WHERE outcome = 'no_response') AS no_response,
  count(*) FILTER (WHERE outcome = 'replied_negative' OR outcome = 'unsubscribed') AS negative_outcomes,
  CASE WHEN count(*) > 0
    THEN round((count(*) FILTER (WHERE outcome IN ('replied_positive', 'booked_demo', 'converted'))::decimal / count(*)) * 100, 2)
    ELSE 0
  END AS positive_rate_pct,
  round(avg(response_time_hours) FILTER (WHERE response_time_hours IS NOT NULL), 1) AS avg_response_hours,
  round(avg(personalization_depth), 1) AS avg_personalization
FROM outreach_intelligence
WHERE outcome != 'pending'
GROUP BY audience_type, channel, intent, tone, angle, hook_type, personalization_depth
HAVING count(*) >= 5;

-- Best subject lines by audience
CREATE OR REPLACE VIEW v_best_subject_lines AS
SELECT
  audience_type,
  subject_line,
  count(*) AS times_used,
  count(*) FILTER (WHERE outcome IN ('replied_positive', 'booked_demo', 'converted')) AS positive_outcomes,
  CASE WHEN count(*) > 0
    THEN round((count(*) FILTER (WHERE outcome IN ('replied_positive', 'booked_demo', 'converted'))::decimal / count(*)) * 100, 2)
    ELSE 0
  END AS positive_rate_pct
FROM outreach_intelligence
WHERE channel = 'email' AND subject_line IS NOT NULL AND outcome != 'pending'
GROUP BY audience_type, subject_line
HAVING count(*) >= 3
ORDER BY positive_rate_pct DESC;

-- Best time to reach out by audience
CREATE OR REPLACE VIEW v_best_outreach_timing AS
SELECT
  audience_type,
  channel,
  day_of_week,
  hour_of_day,
  count(*) AS total_sent,
  count(*) FILTER (WHERE outcome IN ('replied_positive', 'booked_demo', 'converted')) AS positive_outcomes,
  CASE WHEN count(*) > 0
    THEN round((count(*) FILTER (WHERE outcome IN ('replied_positive', 'booked_demo', 'converted'))::decimal / count(*)) * 100, 2)
    ELSE 0
  END AS positive_rate_pct
FROM outreach_intelligence
WHERE outcome != 'pending'
GROUP BY audience_type, channel, day_of_week, hour_of_day
HAVING count(*) >= 5
ORDER BY positive_rate_pct DESC;
