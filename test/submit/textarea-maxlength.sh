browser_state="$NETERO_STATE/browser/1"
tab_state="$browser_state/tab/1"

cat >"$tab_state/page.html" <<EOF
<form action="/form" method="post">
  <textarea name="loremInput" maxlength="2">
  </textarea>
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
Error: textarea too long: loremInput
Max length: 2
Data length: 3
Data path: lorem.txt
Data: foo
EOF

diff --unified --color=always expected.txt actual.txt
