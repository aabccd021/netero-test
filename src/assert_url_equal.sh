expected=${1:-}

if [ -z "$expected" ]; then
  echo "Usage: assert_url_equal <expected>"
  exit 1
fi

tmpdir=$(mktemp -d)
printf "%s" "$expected" >"$tmpdir/expected"
cp "$NETERO_DIR/url.txt" "$tmpdir/actual"

chmod 700 -R "$tmpdir"

diff --color=always --unified "$tmpdir/actual" "$tmpdir/expected"
