browser_state="$NETERO_STATE/browser/1"
tab_state="$browser_state/tab/1"

queryStr=${1:-}

if [ -z "$queryStr" ]; then
  echo "Usage: assert_query_returns_non_empty <queryStr>"
  exit 1
fi

query_result=$(xidel "$tab_state/page.html" --silent --extract "$queryStr")
if [ -z "$query_result" ]; then
  echo "Error: assert_query_returns_non_empty $*"
  exit 1
fi
