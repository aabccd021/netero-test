regex=${1:-}

if [ -z "$regex" ]; then
  echo "Usage: assert-url-regex <regex>"
  exit 1
fi

actual="$(cat "$NETERO_STATE/url.txt")"

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
