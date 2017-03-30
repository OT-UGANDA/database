INSERT INTO system.version SELECT '1703b' WHERE NOT EXISTS (SELECT version_num FROM system.version WHERE version_num = '1703b');

CREATE TABLE opentenure.restriction
(
  id character varying(40) NOT NULL DEFAULT uuid_generate_v1(), 
  claim_id character varying(40) NOT NULL,
  type_code character varying(20) NOT NULL,
  amount numeric(29,2),
  start_date date, 
  end_date date, 
  interest_rate numeric(5,2),
  registration_date timestamp without time zone NOT NULL DEFAULT now(),
  termination_date timestamp without time zone,
  status character(1) NOT NULL DEFAULT 'a'::bpchar,
  rowidentifier character varying(40) NOT NULL DEFAULT uuid_generate_v1(), 
  rowversion integer NOT NULL DEFAULT 0, 
  change_action character(1) NOT NULL DEFAULT 'i'::bpchar,
  change_user character varying(50), 
  change_time timestamp without time zone NOT NULL DEFAULT now(), 
  CONSTRAINT restriction_pkey PRIMARY KEY (id),
  CONSTRAINT restriction_claim_id_fk FOREIGN KEY (claim_id)
      REFERENCES opentenure.claim (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT restriction_type_fk FOREIGN KEY (type_code)
      REFERENCES administrative.rrr_type (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE opentenure.restriction
  OWNER TO postgres;
COMMENT ON TABLE opentenure.restriction
  IS 'Various claim restrictions.';
COMMENT ON COLUMN opentenure.restriction.id IS 'Unique identifier for the restriction.';
COMMENT ON COLUMN opentenure.restriction.claim_id IS 'Claim ID.';
COMMENT ON COLUMN opentenure.restriction.type_code IS 'Restriction type code.';
COMMENT ON COLUMN opentenure.restriction.amount IS 'Mortgage amount';
COMMENT ON COLUMN opentenure.restriction.start_date IS 'Restriction start date. For mortgage start date of payment.';
COMMENT ON COLUMN opentenure.restriction.end_date IS 'Restriction end date.';
COMMENT ON COLUMN opentenure.restriction.interest_rate IS 'Mortgage interest rate.';
COMMENT ON COLUMN opentenure.restriction.registration_date IS 'Date when restriction was registered.';
COMMENT ON COLUMN opentenure.restriction.termination_date IS 'Date when restriction was terminated.';
COMMENT ON COLUMN opentenure.restriction.status IS 'Indicating the status of the restriction. a - active (approved), h - historic, p - pending.';
COMMENT ON COLUMN opentenure.restriction.rowidentifier IS 'Identifies the all change records for the row in the document_historic table';
COMMENT ON COLUMN opentenure.restriction.rowversion IS 'Sequential value indicating the number of times this row has been modified.';
COMMENT ON COLUMN opentenure.restriction.change_action IS 'Indicates if the last data modification action that occurred to the row was insert (i), update (u) or delete (d).';
COMMENT ON COLUMN opentenure.restriction.change_user IS 'The user id of the last person to modify the row.';
COMMENT ON COLUMN opentenure.restriction.change_time IS 'The date and time the row was last modified.';

CREATE TABLE opentenure.restriction_historic
(
  id character varying(40), 
  claim_id character varying(40),
  type_code character varying(20),
  amount numeric(29,2),
  start_date date, 
  end_date date, 
  interest_rate numeric(5,2),
  registration_date timestamp without time zone,
  termination_date timestamp without time zone,
  status character(1),
  rowidentifier character varying(40), 
  rowversion integer, 
  change_action character(1),
  change_user character varying(50), 
  change_time timestamp without time zone, 
  change_time_valid_until timestamp without time zone NOT NULL DEFAULT now()
)
WITH (
  OIDS=FALSE
);
ALTER TABLE opentenure.restriction_historic
  OWNER TO postgres;

CREATE TRIGGER __track_changes
  BEFORE INSERT OR UPDATE
  ON opentenure.restriction
  FOR EACH ROW
  EXECUTE PROCEDURE public.f_for_trg_track_changes();

CREATE TRIGGER __track_history
  AFTER UPDATE OR DELETE
  ON opentenure.restriction
  FOR EACH ROW
  EXECUTE PROCEDURE public.f_for_trg_track_history();

CREATE TABLE opentenure.party_for_restriction
(
  party_id character varying(40) NOT NULL,
  restriction_id character varying(40) NOT NULL, 
  rowidentifier character varying(40) NOT NULL DEFAULT uuid_generate_v1(), 
  rowversion integer NOT NULL DEFAULT 0, 
  change_action character(1) NOT NULL DEFAULT 'i'::bpchar, 
  change_user character varying(50), 
  change_time timestamp without time zone NOT NULL DEFAULT now(), 
  CONSTRAINT party_for_restriction_pkey PRIMARY KEY (party_id, restriction_id),
  CONSTRAINT party_for_restriction_restriction_id_fk FOREIGN KEY (restriction_id)
      REFERENCES opentenure.restriction (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT party_for_restriction_party_id_fk FOREIGN KEY (party_id)
      REFERENCES opentenure.party (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE opentenure.party_for_restriction
  OWNER TO postgres;
COMMENT ON TABLE opentenure.party_for_restriction
  IS 'Identifies parties involved in the restriction.';
COMMENT ON COLUMN opentenure.party_for_restriction.party_id IS 'Identifier for the party.';
COMMENT ON COLUMN opentenure.party_for_restriction.restriction_id IS 'Identifier of the restriction.';
COMMENT ON COLUMN opentenure.party_for_restriction.rowidentifier IS 'Identifies the all change records for the row in the party_for_claim_share_historic table';
COMMENT ON COLUMN opentenure.party_for_restriction.rowversion IS 'Sequential value indicating the number of times this row has been modified.';
COMMENT ON COLUMN opentenure.party_for_restriction.change_action IS 'Indicates if the last data modification action that occurred to the row was insert (i), update (u) or delete (d).';
COMMENT ON COLUMN opentenure.party_for_restriction.change_user IS 'The user id of the last person to modify the row.';
COMMENT ON COLUMN opentenure.party_for_restriction.change_time IS 'The date and time the row was last modified.';

CREATE TABLE opentenure.party_for_restriction_historic
(
  party_id character varying(40),
  restriction_id character varying(40), 
  rowidentifier character varying(40), 
  rowversion integer, 
  change_action character(1), 
  change_user character varying(50), 
  change_time timestamp without time zone, 
  change_time_valid_until timestamp without time zone NOT NULL DEFAULT now()
)
WITH (
  OIDS=FALSE
);
ALTER TABLE opentenure.party_for_restriction_historic
  OWNER TO postgres;
  
CREATE TRIGGER __track_changes
  BEFORE INSERT OR UPDATE
  ON opentenure.party_for_restriction
  FOR EACH ROW
  EXECUTE PROCEDURE public.f_for_trg_track_changes();

CREATE TRIGGER __track_history
  AFTER UPDATE OR DELETE
  ON opentenure.party_for_restriction
  FOR EACH ROW
  EXECUTE PROCEDURE public.f_for_trg_track_history();
