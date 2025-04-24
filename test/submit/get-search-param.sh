browser_state=$(cat "$NETERO_BROWSER_STATE_FILE")

cat >"$browser_state/page.html" <<EOF
<form action="/form?dolorInput=amet&hunterInput=netero">
  <input type="text" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt"

printf "GET http://localhost:8080/form?dolorInput=amet&hunterInput=netero&loremInput=foo" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt
