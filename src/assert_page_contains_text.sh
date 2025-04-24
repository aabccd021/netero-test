NETERO_DIR=$(cat "$NETERO_BROWSER_STATE_FILE")

expected=${1:-}

if [ -z "$expected" ]; then
  echo "Usage: assert_page_contains_text <expected>"
  exit 1
fi

if ! grep -q "$expected" "$NETERO_DIR/page.html"; then
  echo "Error: Text not found in page"
  echo "Text:"
  echo "$expected"
  exit 1
fi
