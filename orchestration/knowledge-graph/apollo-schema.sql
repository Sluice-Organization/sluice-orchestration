-- Apollo.io enrichment columns for cold_email_leads table
-- Run this migration against the Supabase project (wjukfdziomnejtlmegvv)
-- These columns store the richer data from Apollo's company + people search APIs

ALTER TABLE cold_email_leads
  ADD COLUMN IF NOT EXISTS title text,
  ADD COLUMN IF NOT EXISTS seniority text,
  ADD COLUMN IF NOT EXISTS company_size text,
  ADD COLUMN IF NOT EXISTS annual_revenue text,
  ADD COLUMN IF NOT EXISTS linkedin_url text,
  ADD COLUMN IF NOT EXISTS technologies jsonb,
  ADD COLUMN IF NOT EXISTS apollo_id text,
  ADD COLUMN IF NOT EXISTS apollo_org_id text;

-- Index on apollo_id for dedup checks during enrichment
CREATE INDEX IF NOT EXISTS idx_cold_email_leads_apollo_id
  ON cold_email_leads (apollo_id)
  WHERE apollo_id IS NOT NULL;

-- Index on apollo_org_id for org-level lookups
CREATE INDEX IF NOT EXISTS idx_cold_email_leads_apollo_org_id
  ON cold_email_leads (apollo_org_id)
  WHERE apollo_org_id IS NOT NULL;

-- Add stripe_price columns to businesses table for deploy-business pipeline
ALTER TABLE businesses
  ADD COLUMN IF NOT EXISTS stripe_price_solo text,
  ADD COLUMN IF NOT EXISTS stripe_price_pro text,
  ADD COLUMN IF NOT EXISTS stripe_price_shop text;
