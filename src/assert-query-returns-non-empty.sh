queryStr=${1:-}

if [ -z "$queryStr" ]; then
  echo "Usage: assert-query-returns-non-empty <queryStr>"
  exit 1
fi

query_result=$(xidel "$NETERO_STATE/page.html" --silent --extract "$queryStr")
if [ -z "$query_result" ]; then
  echo "Error: assert-query-returns-non-empty $*"
  exit 1
fi
