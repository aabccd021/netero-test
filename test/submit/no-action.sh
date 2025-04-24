browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

echo "http://localhost:8080/myform" >"$tab_state/url.txt"

cat >"$tab_state/page.html" <<EOF
<form method="post">
  <button type="submit">Submit</button>
</form>
EOF

submit "//form"

printf "POST http://localhost:8080/myform" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt
