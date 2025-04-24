browser_state=$(cat "$NETERO_STATE")
tab_state="$browser_state/tab/1"

expected=${1:-}

if [ -z "$expected" ]; then
  echo "Usage: assert_page_contains_text <expected>"
  exit 1
fi

if ! grep -q "$expected" "$tab_state/page.html"; then
  echo "Error: Text not found in page"
  echo "Text:"
  echo "$expected"
  exit 1
fi
