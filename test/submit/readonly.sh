browser_state="$NETERO_STATE/browser/1"
tab_state="$browser_state/tab/1"

cat >"$tab_state/page.html" <<EOF
<form action="/form" method="post">
  <input type="text" name="loremInput" readonly>
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

echo "Error: Readonly input: loremInput" >expected.txt
diff --unified --color=always expected.txt actual.txt
