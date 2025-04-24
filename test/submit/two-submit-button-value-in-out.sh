browser_state=$(cat "$NETERO_BROWSER_STATE_FILE")

cat >"$browser_state/page.html" <<EOF
<form action="/form" method="post" id="myForm">
  <input type="text" name="loremInput">
  <button name="buttonValue" value="foo">Submit foo</button>
</form>
<button form="myForm" name="buttonValue" value="bar">Submit bar</button>
EOF

err_code=0
printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt" 2>actual.txt || err_code=$?

if [ "$err_code" -ne 1 ]; then
  echo "Error: Expected exit code 1, got $err_code"
  exit 1
fi

cat >expected.txt <<EOF
Error: Multiple submit buttons with 'name' attribute found.
Please select one using the '--submit-button' option.
EOF
diff --unified --color=always expected.txt actual.txt
