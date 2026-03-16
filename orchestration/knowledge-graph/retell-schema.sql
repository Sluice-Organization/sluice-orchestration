-- Retell AI voice agent columns for businesses table
-- Run this migration to support per-business Retell AI voice agents

ALTER TABLE businesses ADD COLUMN IF NOT EXISTS retell_agent_id text;
ALTER TABLE businesses ADD COLUMN IF NOT EXISTS retell_voice text;
ALTER TABLE businesses ADD COLUMN IF NOT EXISTS retell_phone_number text;
ALTER TABLE businesses ADD COLUMN IF NOT EXISTS site_url text;
ALTER TABLE businesses ADD COLUMN IF NOT EXISTS repo_name text;
ALTER TABLE businesses ADD COLUMN IF NOT EXISTS cal_booking_url text DEFAULT 'https://cal.com/shalinp';
