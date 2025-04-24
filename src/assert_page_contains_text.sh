browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

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
