NETERO_DIR=$(cat "$NETERO_BROWSER_STATE_FILE")

cat >"$NETERO_DIR/page.html" <<EOF
<form action="/form" method="post">
  <input type="file" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt"

printf "lorem.txt" >./expected.txt
diff --unified --color=always ./expected.txt ./received/loremInput
