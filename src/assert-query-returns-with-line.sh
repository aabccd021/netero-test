browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

queryStr=${1:-}
expectedLine=${2:-}

if [ -z "$expectedLine" ] || [ -z "$queryStr" ]; then
  echo "Usage: assert-query-returns-with-line <expectedLine> <queryStr>"
  exit 1
fi

query_result=$(xidel "$tab_state/page.html" --silent --extract "$queryStr")
while IFS= read -r line; do
  if [ "$line" = "$expectedLine" ]; then
    exit 0
  fi
done <<EOF
$query_result
EOF

echo "Expected query '$queryStr' to return lines containing '$expectedLine', but it didn't" >&2
echo "Actual lines:"
echo "$query_result" >&2
exit 1
