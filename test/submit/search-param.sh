browser_state="$NETERO_STATE/browser/1"
tab_state="$browser_state/tab/1"

cat >"$tab_state/page.html" <<EOF
<form method="post" action="/form?dolorInput=amet&hunterInput=netero">
  <input type="text" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt"

diff --unified --color=always ./lorem.txt ./received/loremInput

printf "POST http://localhost:8080/form?dolorInput=amet&hunterInput=netero" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt
