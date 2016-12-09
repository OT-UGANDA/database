INSERT INTO system.version SELECT '1612a' WHERE NOT EXISTS (SELECT version_num FROM system.version WHERE version_num = '1612a');

INSERT INTO system.approle(code, display_value, status, description)
    VALUES ('PrintCertificate', 'Print certificate and Form 23', 'c', 'Allows to print owership certificate and Form 23');

INSERT INTO system.approle_appgroup(approle_code, appgroup_id) VALUES ('PrintCertificate', 'super-group-id');

-- New doc types
INSERT INTO source.administrative_source_type(code, display_value, status, description, is_for_registration)
    VALUES ('abstract_book', 'Abstract book', 'c', '', 'f');

INSERT INTO source.administrative_source_type(code, display_value, status, description, is_for_registration)
    VALUES ('signed_cco', 'Signed CCO', 'c', '', 'f');

INSERT INTO source.administrative_source_type(code, display_value, status, description, is_for_registration)
    VALUES ('dlb_minutes', 'DLB minutes', 'c', '', 'f');

INSERT INTO opentenure.claim_status(code, display_value, status, description)
    VALUES ('issued', 'Issued', 'c', 'Final status for the claim, indicating it is issued to the owner');

INSERT INTO system.setting(name, vl, active, description) VALUES ('docs-for-issuing-cco', 'abstract_book,signed_cco', 't', 'List of document type codes, required to set CCO issued status');

ALTER TABLE opentenure.claim ADD COLUMN issuance_date timestamp without time zone;
COMMENT ON COLUMN opentenure.claim.issuance_date IS 'Claim issuance date';

ALTER TABLE opentenure.claim_historic ADD COLUMN issuance_date timestamp without time zone;

