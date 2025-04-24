NETERO_DIR=$(cat "$NETERO_BROWSER_STATE_FILE")

echo "http://localhost:8080/myform" >"$NETERO_DIR/url.txt"

cat >"$NETERO_DIR/page.html" <<EOF
<form method="post">
  <button type="submit">Submit</button>
</form>
EOF

submit "//form"

printf "POST http://localhost:8080/myform" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt
