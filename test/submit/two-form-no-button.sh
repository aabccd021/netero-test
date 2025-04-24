browser_state="$NETERO_STATE/browser/1"
tab_state="$browser_state/tab/1"

cat >"$tab_state/page.html" <<EOF
<form action="/form" method="post" id="no-button">
  <input type="text" name="loremInput">
</form>
<form action="/form" method="post" id="with-button">
  <input type="text" name="loremInput">
  <button>Submit foo</button>
</form>
EOF

err_code=0
printf "foo" >lorem.txt
submit "//form[@id='no-button']" --data "loremInput=lorem.txt" 2>actual.txt || err_code=$?

if [ "$err_code" -ne 1 ]; then
  echo "Error: Expected exit code 1, got $err_code"
  exit 1
fi

echo "Error: Submit button not found" >expected.txt
diff --unified --color=always expected.txt actual.txt
