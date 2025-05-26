#!/bin/bash

# Wait for PostgreSQL to be ready
until PGPASSWORD=skyvern psql -h postgres -U skyvern -d skyvern -c '\q'; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done

echo "PostgreSQL is up - executing initialization script"

# Create organization
PGPASSWORD=skyvern psql -h postgres -U skyvern -d skyvern << EOF
INSERT INTO organizations (organization_id, organization_name, created_at, modified_at)
VALUES ('o_397638930670029114', 'Default Organization', NOW(), NOW())
ON CONFLICT (organization_id) DO NOTHING;
EOF

# Create API token
PGPASSWORD=skyvern psql -h postgres -U skyvern -d skyvern << EOF
INSERT INTO organization_auth_tokens (id, organization_id, token_type, token, valid, created_at, modified_at)
VALUES ('t_1', 'o_397638930670029114', 'api', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjQ4OTMyMjU3MjgsInN1YiI6Im9fMzk3NjM4OTMwNjcwMDI5MTE0In0.0PYAaPzI92uxXgF2h_x-ii5v64FUQ6RvH-LKNPImm_U', true, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;
EOF

echo "Database initialization completed" 