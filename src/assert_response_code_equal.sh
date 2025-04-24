browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

expected=${1:-}

if [ -z "$expected" ]; then
  echo "Usage: assert_response_code_equal <expected>" >&2
  exit 1
fi

actual=$(jq -r .response_code "$tab_state/response.json")
if [ "$expected" != "$actual" ]; then
  echo "Error: assert_response_code_equal $*" >&2
  echo "Actual error code: $actual" >&2
  exit 1
fi
