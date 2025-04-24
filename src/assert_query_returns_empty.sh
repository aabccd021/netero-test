NETERO_DIR=$(cat "$NETERO_BROWSER_STATE_FILE")

queryStr=${1:-}

if [ -z "$queryStr" ]; then
  echo "Usage: assert_query_returns_empty <queryStr>"
  exit 1
fi

query_result=$(xidel "$NETERO_DIR/page.html" --silent --extract "$queryStr")
if [ -n "$query_result" ]; then
  echo "Assertion error: assert_query_returns_empty \"$queryStr\""
  echo "expected empty, but got:"
  echo "$query_result"
  exit 1
fi
