cat >"$NETERO_STATE/page.html" <<EOF
<form action="/form">
  <input type="text" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

printf "301" >./redirect-code.txt
printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt"

printf "GET http://localhost:8080/form?loremInput=foo" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt

printf "<p>Redirected</p>" >./expected.txt
diff --unified --color=always ./expected.txt "$NETERO_STATE/page.html"
