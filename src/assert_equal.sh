expected=${1:-}
actual=${2:-}

if [ -z "$expected" ]; then
  echo "Usage: assert_equal <expected> <actual>"
  exit 1
fi

tmpdir=$(mktemp -d)
printf "%s" "$expected" >"$tmpdir/expected"
printf "%s" "$actual" >"$tmpdir/actual"

diff --color=always --unified "$tmpdir/actual" "$tmpdir/expected"
