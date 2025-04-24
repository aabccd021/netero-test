browser_state="$NETERO_STATE/browser/1"
tab_state="$browser_state/tab/1"

queryStr=${1:-}

if [ -z "$queryStr" ]; then
  echo "Usage: assert_query_returns_empty <queryStr>"
  exit 1
fi

query_result=$(xidel "$tab_state/page.html" --silent --extract "$queryStr")
if [ -n "$query_result" ]; then
  echo "Assertion error: assert_query_returns_empty \"$queryStr\""
  echo "expected empty, but got:"
  echo "$query_result"
  exit 1
fi
