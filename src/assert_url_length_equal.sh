NETERO_DIR=$(cat "$NETERO_BROWSER_STATE_FILE")

expected=${1:-}

if [ -z "$expected" ]; then
  echo "Usage: assert_url_length_equal <expected>"
  exit 1
fi

url=$(cat "$NETERO_DIR/url.txt")
url_length=${#url}
if [ "$url_length" -eq "$expected" ]; then
  exit 0
fi

echo "Expected URL length to be $expected, but it was $url_length" >&2
exit 1
