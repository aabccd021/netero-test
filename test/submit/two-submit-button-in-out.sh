browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

cat >"$tab_state/page.html" <<EOF
<form action="/form" method="post" id="myForm">
  <input type="text" name="loremInput">
  <button>Submit foo</button>
</form>
<button form="myForm">Submit bar</button>
EOF

printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt"

diff --unified --color=always ./lorem.txt ./received/loremInput

printf "POST http://localhost:8080/form" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt
