cat >"$NETERO_DIR/page.html" <<EOF
<form action="/form" method="post" id="without-button">
  <input type="text" name="loremInput">
  <button></button>
</form>
<form action="/form" method="post" id="with-button">
  <input type="text" name="loremInput">
  <button></button>
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

cat >expected.txt <<EOF
Error: Multiple forms found.
Please make the form query more specific.
EOF
diff --unified --color=always expected.txt actual.txt
