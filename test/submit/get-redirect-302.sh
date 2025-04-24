browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

cat >"$tab_state/page.html" <<EOF
<form action="/form">
  <input type="text" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

printf "302" >./redirect-code.txt
printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt"

printf "GET http://localhost:8080/form?loremInput=foo" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt

printf "<p>Redirected</p>" >./expected.txt
diff --unified --color=always ./expected.txt "$tab_state/page.html"
