browser_state=$(cat "$NETERO_BROWSER_STATE_FILE")

cat >"$browser_state/page.html" <<EOF
<form action="/form" method="post">
  <input type="text" name="loremInput" minlength="4">
  <button type="submit">Submit</button>
</form>
EOF

printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt" 2>actual.txt || err_code=$?

if [ "$err_code" -ne 1 ]; then
  echo "Error: Expected exit code 1, got $err_code"
  cat actual.txt
  exit 1
fi

cat >expected.txt <<EOF
Error: input too short: loremInput
Min length: 4
Data length: 3
Data path: lorem.txt
Data: foo
EOF

diff --unified --color=always expected.txt actual.txt
