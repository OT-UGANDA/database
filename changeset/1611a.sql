INSERT INTO system.version SELECT '1611a' WHERE NOT EXISTS (SELECT version_num FROM system.version WHERE version_num = '1611a');

INSERT INTO system.setting(name, vl, active, description) VALUES ('form23_report_url', '/reports/cert/Form23', 't', 'Path to form23 report');
