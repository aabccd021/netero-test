browser_state=$(cat "$NETERO_STATE")
tab_state="$browser_state/tab/1"

cat >"$tab_state/page.html" <<EOF
<form action="/form" method="post" enctype="multipart/form-data">
  <input type="file" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

submit "//form"

printf "" >./expected.txt
diff --unified --color=always ./expected.txt ./received/loremInput
