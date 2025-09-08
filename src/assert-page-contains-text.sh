expected=${1:-}

if [ -z "$expected" ]; then
  echo "Usage: assert-page-contains-text <expected>"
  exit 1
fi

if ! grep -q "$expected" "$NETERO_STATE/page.html"; then
  echo "Error: Text not found in page"
  echo "Text:"
  echo "$expected"
  exit 1
fi
