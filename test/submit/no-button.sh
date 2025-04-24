browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

cat >"$tab_state/page.html" <<EOF
<form action="/form" method="post">
  <input type="text" name="loremInput">
</form>
EOF

err_code=0
printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt" 2>actual.txt || err_code=$?

if [ "$err_code" -ne 1 ]; then
  echo "Error: Expected exit code 1, got $err_code"
  cat actual.txt
  exit 1
fi

echo "Error: Submit button not found" >expected.txt
diff --unified --color=always expected.txt actual.txt
