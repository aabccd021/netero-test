NETERO_DIR=$(cat "$NETERO_BROWSER_STATE_FILE")

cat >"$NETERO_DIR/page.html" <<EOF
<form action="/form">
  <input type="text" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt"

printf "GET http://localhost:8080/form?loremInput=foo" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt
