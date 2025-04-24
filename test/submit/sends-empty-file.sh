browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

cat >"$tab_state/page.html" <<EOF
<form action="/form" method="post" enctype="multipart/form-data">
  <input type="file" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

submit "//form"

printf "" >./expected.txt
diff --unified --color=always ./expected.txt ./received/loremInput
