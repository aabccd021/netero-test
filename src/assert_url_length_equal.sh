browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

expected=${1:-}

if [ -z "$expected" ]; then
  echo "Usage: assert_url_length_equal <expected>"
  exit 1
fi

url=$(cat "$tab_state/url.txt")
url_length=${#url}
if [ "$url_length" -eq "$expected" ]; then
  exit 0
fi

echo "Expected URL length to be $expected, but it was $url_length" >&2
exit 1
