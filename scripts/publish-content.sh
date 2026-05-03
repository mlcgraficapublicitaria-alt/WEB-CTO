#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/publish-content.sh <slug> [page|post] [publish|draft|private|pending]

Required environment variables:
  PROD_WP_BASE_URL
  PROD_WP_USERNAME
  PROD_WP_APP_PASSWORD

Example:
  PROD_WP_BASE_URL="https://holisticaysalud.es" \
  PROD_WP_USERNAME="admin" \
  PROD_WP_APP_PASSWORD="xxxx xxxx xxxx xxxx xxxx xxxx" \
  ./scripts/publish-content.sh osteopatia-estructural page publish
EOF
}

if [[ "${1:-}" == "" ]]; then
  usage
  exit 1
fi

for required_cmd in wp php curl; do
  if ! command -v "$required_cmd" >/dev/null 2>&1; then
    echo "Missing required command: $required_cmd" >&2
    exit 1
  fi
done

: "${PROD_WP_BASE_URL:?Missing PROD_WP_BASE_URL}"
: "${PROD_WP_USERNAME:?Missing PROD_WP_USERNAME}"
: "${PROD_WP_APP_PASSWORD:?Missing PROD_WP_APP_PASSWORD}"

SLUG="$1"
POST_TYPE="${2:-page}"
TARGET_STATUS="${3:-publish}"

case "$POST_TYPE" in
  page)
    REST_COLLECTION="pages"
    ;;
  post)
    REST_COLLECTION="posts"
    ;;
  *)
    echo "Unsupported post type: $POST_TYPE" >&2
    exit 1
    ;;
esac

case "$TARGET_STATUS" in
  publish|draft|private|pending)
    ;;
  *)
    echo "Unsupported target status: $TARGET_STATUS" >&2
    exit 1
    ;;
esac

LOCAL_ID="$(wp post list --post_type="$POST_TYPE" --name="$SLUG" --post_status=any --posts_per_page=1 --field=ID --format=ids)"

if [[ -z "$LOCAL_ID" ]]; then
  echo "No local $POST_TYPE found with slug: $SLUG" >&2
  exit 1
fi

LOCAL_TITLE="$(wp post get "$LOCAL_ID" --field=post_title)"
LOCAL_CONTENT="$(wp post get "$LOCAL_ID" --field=post_content)"
LOCAL_EXCERPT="$(wp post get "$LOCAL_ID" --field=post_excerpt)"
LOCAL_TEMPLATE="$(wp post meta get "$LOCAL_ID" _wp_page_template 2>/dev/null || true)"

if [[ -z "$LOCAL_TEMPLATE" ]]; then
  LOCAL_TEMPLATE="default"
fi

export LOCAL_TITLE LOCAL_CONTENT LOCAL_EXCERPT SLUG TARGET_STATUS LOCAL_TEMPLATE

PAYLOAD="$(php -r '
  $payload = [
    "title" => getenv("LOCAL_TITLE"),
    "content" => getenv("LOCAL_CONTENT"),
    "excerpt" => getenv("LOCAL_EXCERPT"),
    "slug" => getenv("SLUG"),
    "status" => getenv("TARGET_STATUS"),
  ];

  if (getenv("LOCAL_TEMPLATE") !== "" && getenv("LOCAL_TEMPLATE") !== "default") {
    $payload["template"] = getenv("LOCAL_TEMPLATE");
  }

  echo json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
')"

AUTH_HEADER="Authorization: Basic $(printf '%s:%s' "$PROD_WP_USERNAME" "$PROD_WP_APP_PASSWORD" | base64)"
API_BASE="${PROD_WP_BASE_URL%/}/wp-json/wp/v2/${REST_COLLECTION}"

EXISTING_JSON="$(curl -sS --fail \
  -H "$AUTH_HEADER" \
  "${API_BASE}?slug=${SLUG}")"

EXISTING_ID="$(printf '%s' "$EXISTING_JSON" | php -r '
  $data = json_decode(stream_get_contents(STDIN), true);
  if (! is_array($data) || empty($data[0]["id"])) {
    exit(0);
  }
  echo $data[0]["id"];
')"

if [[ -n "$EXISTING_ID" ]]; then
  echo "Updating ${POST_TYPE} '${SLUG}' on production (ID ${EXISTING_ID})..."
  RESPONSE="$(curl -sS --fail \
    -X POST \
    -H "$AUTH_HEADER" \
    -H "Content-Type: application/json" \
    --data "$PAYLOAD" \
    "${API_BASE}/${EXISTING_ID}")"
else
  echo "Creating ${POST_TYPE} '${SLUG}' on production..."
  RESPONSE="$(curl -sS --fail \
    -X POST \
    -H "$AUTH_HEADER" \
    -H "Content-Type: application/json" \
    --data "$PAYLOAD" \
    "${API_BASE}")"
fi

printf '%s' "$RESPONSE" | php -r '
  $data = json_decode(stream_get_contents(STDIN), true);
  if (! is_array($data)) {
    fwrite(STDERR, "Unexpected response from WordPress REST API\n");
    exit(1);
  }

  $id = $data["id"] ?? "unknown";
  $link = $data["link"] ?? "no-link";
  $status = $data["status"] ?? "unknown";

  echo "Done. Remote ID: {$id}\n";
  echo "Status: {$status}\n";
  echo "Link: {$link}\n";
'
