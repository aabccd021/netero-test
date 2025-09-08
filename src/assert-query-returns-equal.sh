queryStr=${1:-}
expected=${2:-}

if [ -z "$expected" ] || [ -z "$queryStr" ]; then
  echo "Usage: assert-query-returns-equal <expected> <queryStr>"
  exit 1
fi

tmpdir=$(mktemp -d)
echo "$expected" >"$tmpdir/expected"
xidel "$NETERO_STATE/page.html" --silent --extract "$queryStr" >"$tmpdir/actual"

err_code=0
diff --color=always --unified "$tmpdir/actual" "$tmpdir/expected" || err_code=$?

if [ "$err_code" -ne 0 ]; then
  echo "Failed assertion: assert-query-returns-equal"
  echo "Query: $queryStr"
  echo ""
  echo "Expected: "
  cat "$tmpdir/expected"
  echo ""
  echo "Actual:"
  cat "$tmpdir/actual"
  exit 1
fi
