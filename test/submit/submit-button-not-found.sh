NETERO_DIR=$(cat "$NETERO_BROWSER_STATE_FILE")

cat >"$NETERO_DIR/page.html" <<EOF
<form action="/form">
  <input type="text" name="loremInput">
</form>
EOF

submit "//form" 2>actual.txt || err_code=$?

if [ "$err_code" -ne 1 ]; then
  echo "Error: Expected exit code 1, got $err_code"
  exit 1
fi

echo "Error: Submit button not found" >expected.txt
diff --unified --color=always expected.txt actual.txt
