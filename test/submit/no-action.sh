echo "http://localhost:8080/myform" >"$NETERO_STATE/url.txt"

cat >"$NETERO_STATE/page.html" <<EOF
<form method="post">
  <button type="submit">Submit</button>
</form>
EOF

submit "//form"

printf "POST http://localhost:8080/myform" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt
