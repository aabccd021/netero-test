browser_state="$NETERO_STATE/browser/1"
tab_state="$browser_state/tab/1"

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
