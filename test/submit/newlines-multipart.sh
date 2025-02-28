cat >"$NETERO_DIR/page.html" <<EOF
<form action="/form" method="post" enctype="multipart/form-data">
  <input type="text" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

printf "\n\nfoo\n\n" >lorem.txt
submit "//form" --data "loremInput=lorem.txt"

diff --unified --color=always ./lorem.txt ./received/loremInput
