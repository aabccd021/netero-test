expected=${1:-}

if [ -z "$expected" ]; then
  echo "Usage: assert-response-code-equal <expected>" >&2
  exit 1
fi

actual=$(jq -r .response_code "$NETERO_STATE/response.json")
if [ "$expected" != "$actual" ]; then
  echo "Error: assert-response-code-equal $*" >&2
  echo "Actual error code: $actual" >&2
  exit 1
fi
