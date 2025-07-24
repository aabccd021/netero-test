expected=${1:-}
actual=${2:-}

if [ -z "$expected" ] || [ -z "$actual" ]; then
  echo "Usage: assert_snapshot_equal <expected> <actual>" >&2
  exit 1
fi

if [ "${CREATE_SNAPSHOT:-}" = "1" ]; then
  cp "$actual" "$expected"
  exit 0
fi

if ! cmp -s "$expected" "$actual"; then
  echo "Failed assertion: assert_snapshot_equal $*" >&2

  echo "Expected file:"
  ls -l "$expected" || true
  file "$expected" || true

  echo

  echo "Actual file:"
  ls -l "$actual" || true
  file "$actual" || true

  exit 1
fi
