CREATE TABLE schema_version
(
    version_number BIGSERIAL NOT NULL PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO schema_version (created_at) VALUES (CURRENT_TIMESTAMP);

CREATE TABLE resources
(
    id BIGSERIAL NOT NULL PRIMARY KEY,
    resource_data BYTEA NOT NULL,
    resource_name TEXT NOT NULL,
    mime_type TEXT NOT NULL,
    size BIGINT NOT NULL
);