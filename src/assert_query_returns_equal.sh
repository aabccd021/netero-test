browser_state=$(cat "$NETERO_BROWSER_STATE_FILE")
tab_state="$browser_state/tab/1"

queryStr=${1:-}
expected=${2:-}

if [ -z "$expected" ] || [ -z "$queryStr" ]; then
  echo "Usage: assert_query_returns_equal <expected> <queryStr>"
  exit 1
fi

tmpdir=$(mktemp -d)
echo "$expected" >"$tmpdir/expected"
xidel "$tab_state/page.html" --silent --extract "$queryStr" >"$tmpdir/actual"

err_code=0
diff --color=always --unified "$tmpdir/actual" "$tmpdir/expected" || err_code=$?

if [ "$err_code" -ne 0 ]; then
  echo "Failed assertion: assert_query_returns_equal"
  echo "Query: $queryStr"
  echo ""
  echo "Expected: "
  cat "$tmpdir/expected"
  echo ""
  echo "Actual:"
  cat "$tmpdir/actual"
  exit 1
fi
