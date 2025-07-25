browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

regex=${1:-}

if [ -z "$regex" ]; then
  echo "Usage: assert-url-regex <regex>"
  exit 1
fi

actual="$(cat "$tab_state/url.txt")"

if ! echo "$actual" | grep -Eq "$regex"; then
  echo "Assertion error: string does not match regex"
  echo
  echo "regex expected:"
  echo "$regex"
  echo
  echo "string:"
  echo "$actual"
  exit 1
fi
