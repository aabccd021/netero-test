browser_state=$(cat "$NETERO_BROWSER_STATE_FILE")

expected=${1:-}

if [ -z "$expected" ]; then
  echo "Usage: assert_url_equal <expected>"
  exit 1
fi

tmpdir=$(mktemp -d)
printf "%s" "$expected" >"$tmpdir/expected"
cp "$browser_state/url.txt" "$tmpdir/actual"

chmod 700 -R "$tmpdir"

diff --color=always --unified "$tmpdir/actual" "$tmpdir/expected"
