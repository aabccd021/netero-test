browser_state=$(cat "$NETERO_BROWSER_STATE_FILE")
tab_state="$browser_state/tab/1"

cat >"$tab_state/page.html" <<EOF
<form action="/form" method="post">
  <input type="text" name="loremInput">
  <button>Submit foo</button>
  <button>Submit bar</button>
</form>
EOF

printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt"

diff --unified --color=always ./lorem.txt ./received/loremInput

printf "POST http://localhost:8080/form" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt
