browser_state="$NETERO_STATE/browser/1"
tab_state="$browser_state/tab/1"

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
