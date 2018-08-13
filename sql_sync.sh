#!/usr/bin/env bash
set -eu

function finish {
  # Stop background jobs
  kill "$(jobs -p)"
}

trap finish EXIT
cloud_sql_proxy \
  --credential_file=key.json
  -instances="${CLOUDSQL_INSTANCE}=tcp:3306" &

mkdir -p content

sleep 2

echo ""
echo "mysqldump planet4-defaultcontent_wordpress > content/planet4-defaultcontent_wordpress-v${SQL_TAG}.sql ..."
echo ""
mysqldump -v \
  -u "$(echo "${WP_DB_USERNAME}" | base64 -d)" \
  -p"$(echo "${WP_DB_PASSWORD}" | base64 -d)" \
  -h 127.0.0.1 \
  planet4-defaultcontent_wordpress > "content/planet4-defaultcontent_wordpress-v${SQL_TAG}.sql"

echo ""
echo "gzip ..."
echo ""
gzip --verbose --best "content/planet4-defaultcontent_wordpress-v${SQL_TAG}.sql"
gzip --test "content/planet4-defaultcontent_wordpress-v${SQL_TAG}.sql.gz"

echo ""
echo "uploading to ${BUCKET_DESTINATION}/..."
echo ""
gsutil cp "content/planet4-defaultcontent_wordpress-v${SQL_TAG}.sql.gz" "${BUCKET_DESTINATION}/"

gsutil ls "${BUCKET_DESTINATION}/"
