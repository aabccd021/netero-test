browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"
actual="$tab_state/body"

expected=${1:-}

if [ -z "$expected" ]; then
  echo "Usage: assert_snapshot_equal <expected>" >&2
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
