#!/usr/bin/env bash
set -eu

function finish {
  # Stop background jobs
  kill "$(jobs -p)"
}

WP_DB_USERNAME_DC=$(echo "${WP_DB_USERNAME}" | base64 -d)
WP_DB_PASSWORD_DC=$(echo "${WP_DB_PASSWORD}" | base64 -d)
WP_STATELESS_KEY_DC=$(echo "${WP_STATELESS_KEY}" | base64 -d)
CLOUDSQL_INSTANCE=planet-4-151612:us-central1:p4-develop-k8s
export GOOGLE_APPLICATION_CREDENTIALS="/home/circleci/project/key.json"

trap finish EXIT
cloud_sql_proxy \
  -instances="${CLOUDSQL_INSTANCE}=tcp:3306" &

mkdir -p content

sleep 2

echo ""
echo "mysqldump planet4-defaultcontent_wordpress > content/planet4-defaultcontent_wordpress-v${SQL_TAG}.sql ..."
echo ""
mysqldump -v \
  -u "$WP_DB_USERNAME_DC" \
  -p"$WP_DB_PASSWORD_DC" \
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
