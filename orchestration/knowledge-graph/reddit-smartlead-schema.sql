-- Reddit drafts table for community engagement review queue
CREATE TABLE IF NOT EXISTS reddit_drafts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id text NOT NULL,
  post_url text NOT NULL,
  subreddit text NOT NULL,
  post_title text,
  draft_reply text NOT NULL,
  score integer DEFAULT 0,
  mentions_product boolean DEFAULT false,
  status text DEFAULT 'pending', -- pending, approved, rejected, posted
  posted_at timestamptz,
  reddit_comment_id text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX idx_reddit_drafts_status ON reddit_drafts(status);
CREATE INDEX idx_reddit_drafts_business ON reddit_drafts(business_id);
CREATE INDEX idx_reddit_drafts_post_url ON reddit_drafts(post_url);

-- Smartlead campaign tracking per business
CREATE TABLE IF NOT EXISTS smartlead_campaigns (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id text NOT NULL,
  campaign_id text NOT NULL,
  campaign_name text,
  sending_domains jsonb DEFAULT '[]',
  created_at timestamptz DEFAULT now(),
  UNIQUE(business_id, campaign_id)
);

CREATE INDEX idx_smartlead_campaigns_business ON smartlead_campaigns(business_id);

-- RLS
ALTER TABLE reddit_drafts ENABLE ROW LEVEL SECURITY;
ALTER TABLE smartlead_campaigns ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Service role full access on reddit_drafts"
  ON reddit_drafts FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY "Service role full access on smartlead_campaigns"
  ON smartlead_campaigns FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY "Anon can read reddit_drafts"
  ON reddit_drafts FOR SELECT USING (true);
CREATE POLICY "Anon can insert reddit_drafts"
  ON reddit_drafts FOR INSERT WITH CHECK (true);
CREATE POLICY "Anon can read smartlead_campaigns"
  ON smartlead_campaigns FOR SELECT USING (true);
CREATE POLICY "Anon can insert smartlead_campaigns"
  ON smartlead_campaigns FOR INSERT WITH CHECK (true);
