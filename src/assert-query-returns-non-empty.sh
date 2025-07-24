browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

queryStr=${1:-}

if [ -z "$queryStr" ]; then
  echo "Usage: assert-query-returns-non-empty <queryStr>"
  exit 1
fi

query_result=$(xidel "$tab_state/page.html" --silent --extract "$queryStr")
if [ -z "$query_result" ]; then
  echo "Error: assert-query-returns-non-empty $*"
  exit 1
fi
