cat >"$NETERO_STATE/page.html" <<EOF
<form action="/form" method="post">
  <input type="text" name="loremInput" value="foo" required>
  <button type="submit">Submit</button>
</form>
EOF

printf "foo" >expected.txt
submit "//form"

diff --unified --color=always ./expected.txt ./received/loremInput
