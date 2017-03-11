INSERT INTO system.version SELECT '1703a' WHERE NOT EXISTS (SELECT version_num FROM system.version WHERE version_num = '1703a');

ALTER TABLE opentenure.claim_share ADD COLUMN status character(1) NOT NULL DEFAULT 'a';
ALTER TABLE opentenure.claim_share ADD COLUMN registration_date date;
ALTER TABLE opentenure.claim_share ADD COLUMN termination_date date;
COMMENT ON COLUMN opentenure.claim_share.status IS 'Indicating the status of the share. a - active (approved), h - historic, p - pending.';
COMMENT ON COLUMN opentenure.claim_share.registration_date IS 'Registration date of the share. For initial claims must be equal to the date of the claim approval';
COMMENT ON COLUMN opentenure.claim_share.termination_date IS 'Termination date of the share (when share became historic)';

ALTER TABLE opentenure.claim_share_historic ADD COLUMN status character(1);
ALTER TABLE opentenure.claim_share_historic ADD COLUMN registration_date date;
ALTER TABLE opentenure.claim_share_historic ADD COLUMN termination_date date;

UPDATE opentenure.claim_share SET status = 'a';

UPDATE opentenure.claim_share SET registration_date = c.decision_date
FROM opentenure.claim c WHERE c.id = opentenure.claim_share.claim_id AND c.status_code = 'moderated';
