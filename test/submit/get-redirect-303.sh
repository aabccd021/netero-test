browser_state=$(cat "$NETERO_BROWSER_STATE_FILE")
tab_state="$browser_state/tab/1"

cat >"$tab_state/page.html" <<EOF
<form action="/form">
  <input type="text" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

printf "303" >./redirect-code.txt
printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt"

printf "GET http://localhost:8080/form?loremInput=foo" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt

printf "<p>Redirected</p>" >./expected.txt
diff --unified --color=always ./expected.txt "$tab_state/page.html"
