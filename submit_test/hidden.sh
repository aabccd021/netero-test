cat >"$NETERO_DIR/page.html" <<EOF
<form action="/form" method="post">
  <input type="hidden" name="loremInput" value="foo">
  <button type="submit">Submit</button>
</form>
EOF

submit "//form"

printf "foo" >expected.txt
diff --unified --color=always ./expected.txt ./received/loremInput
