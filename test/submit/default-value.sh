browser_state=$(cat "$NETERO_BROWSER_STATE_FILE")
tab_state="$browser_state/tab/1"

cat >"$tab_state/page.html" <<EOF
<form action="/form" method="post">
  <input type="text" name="loremInput" value="foo">
  <button type="submit">Submit</button>
</form>
EOF

submit "//form"

printf "foo" >./expected.txt
diff --unified --color=always ./expected.txt ./received/loremInput
