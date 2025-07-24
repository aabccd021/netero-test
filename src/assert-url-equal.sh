browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

expected=${1:-}

if [ -z "$expected" ]; then
  echo "Usage: assert_url_equal <expected>"
  exit 1
fi

tmpdir=$(mktemp -d)
printf "%s" "$expected" >"$tmpdir/expected"
cp "$tab_state/url.txt" "$tmpdir/actual"

chmod 700 -R "$tmpdir"

diff --color=always --unified "$tmpdir/actual" "$tmpdir/expected"
