cat >"$NETERO_STATE/page.html" <<EOF
<form action="/form" method="post" enctype="multipart/form-data">
  <input type="file" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

submit "//form"

printf "" >./expected.txt
diff --unified --color=always ./expected.txt ./received/loremInput
