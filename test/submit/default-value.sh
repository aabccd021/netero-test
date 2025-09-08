cat >"$NETERO_STATE/page.html" <<EOF
<form action="/form" method="post">
  <input type="text" name="loremInput" value="foo">
  <button type="submit">Submit</button>
</form>
EOF

submit "//form"

printf "foo" >./expected.txt
diff --unified --color=always ./expected.txt ./received/loremInput
