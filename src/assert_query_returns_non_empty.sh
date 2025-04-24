browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

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
