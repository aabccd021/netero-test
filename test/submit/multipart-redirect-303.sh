cat >"$NETERO_STATE/page.html" <<EOF
<form action="/form" method="post" enctype="multipart/form-data">
  <input type="text" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

printf "303" >./redirect-code.txt
printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt"

diff --unified --color=always ./lorem.txt ./received/loremInput

printf "POST http://localhost:8080/form" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt

printf "<p>Redirected</p>" >./expected.txt
diff --unified --color=always ./expected.txt "$NETERO_STATE/page.html"
