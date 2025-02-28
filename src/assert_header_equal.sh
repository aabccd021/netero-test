header=${1:-}
expected=${2:-}

if [ -z "$expected" ] || [ -z "$header" ]; then
  echo "Usage: assert_header_equal <header> <expected>" >&2
  exit 1
fi

actual=$(jq -r ".[\"$header\"][0]" ./header.json)
if [ "$expected" != "$actual" ]; then
  echo "Error: assert_header_equal $*" >&2
  echo "Actual header value: $actual" >&2
  exit 1
fi
