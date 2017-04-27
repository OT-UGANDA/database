INSERT INTO system.version SELECT '1704a' WHERE NOT EXISTS (SELECT version_num FROM system.version WHERE version_num = '1704a');

INSERT INTO opentenure.claim_status(code, display_value, status, description)
    VALUES ('historic', 'Historic', 'c', 'Historic status, indicating that parcel was split or merged.');

CREATE TABLE opentenure.termination_reason
(
  code character varying(20) NOT NULL,
  display_value character varying(500) NOT NULL, 
  status character(1) NOT NULL DEFAULT 't'::bpchar, 
  description character varying(1000), 
  CONSTRAINT termination_reason_pkey PRIMARY KEY (code),
  CONSTRAINT termination_reason_display_value_unique UNIQUE (display_value)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE opentenure.termination_reason
  OWNER TO postgres;
COMMENT ON TABLE opentenure.termination_reason
  IS 'Code list of termination reasons which can happen to the claim.';
COMMENT ON COLUMN opentenure.termination_reason.code IS 'The code for the termination reason.';
COMMENT ON COLUMN opentenure.termination_reason.display_value IS 'Displayed value of the termination reason.';
COMMENT ON COLUMN opentenure.termination_reason.status IS 'Status of the termination reason.';
COMMENT ON COLUMN opentenure.termination_reason.description IS 'Description of the termination reason.';

INSERT INTO opentenure.termination_reason (code, display_value, status, description) VALUES ('merge', 'Parcels merge', 'c', 'Termination as a result of parcels merge');
INSERT INTO opentenure.termination_reason (code, display_value, status, description) VALUES ('split', 'Parcel split', 'c', 'Termination as a result of parcel split');

ALTER TABLE opentenure.claim ADD COLUMN termination_date date;
ALTER TABLE opentenure.claim ADD COLUMN termination_reason_code character varying(20);
ALTER TABLE opentenure.claim ADD COLUMN create_transaction character varying(40);
ALTER TABLE opentenure.claim ADD COLUMN terminate_transaction character varying(40);
ALTER TABLE opentenure.claim ADD CONSTRAINT fk_claim_termination_reason FOREIGN KEY (termination_reason_code) REFERENCES opentenure.termination_reason (code) ON UPDATE NO ACTION ON DELETE NO ACTION;
COMMENT ON COLUMN opentenure.claim.termination_date IS 'Date when claim was terminated';
COMMENT ON COLUMN opentenure.claim.termination_reason_code IS 'Termination reason code';
COMMENT ON COLUMN opentenure.claim.create_transaction IS 'Transaction code, used to create claim. It used for split/merge transaction to link parent and children claims.';
COMMENT ON COLUMN opentenure.claim.terminate_transaction IS 'Transaction code, used to terminate claim. It used for split/merge transaction to link parent and children claims.';

ALTER TABLE opentenure.claim_historic ADD COLUMN termination_date date;
ALTER TABLE opentenure.claim_historic ADD COLUMN termination_reason_code character varying(20);
ALTER TABLE opentenure.claim_historic ADD COLUMN create_transaction character varying(40);
ALTER TABLE opentenure.claim_historic ADD COLUMN terminate_transaction character varying(40);