queryStr=${1:-}

if [ -z "$queryStr" ]; then
  echo "Usage: assert-query-returns-empty <queryStr>"
  exit 1
fi

query_result=$(xidel "$NETERO_STATE/page.html" --silent --extract "$queryStr")
if [ -n "$query_result" ]; then
  echo "Assertion error: assert-query-returns-empty \"$queryStr\""
  echo "expected empty, but got:"
  echo "$query_result"
  exit 1
fi
