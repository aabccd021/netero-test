cat >"$NETERO_DIR/page.html" <<EOF
<form id="myform" action="/form" method="post">
  <input type="text" name="loremInput">
</form>
<button type="submit" form="myform">Submit</button>
EOF

printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt"

diff --unified --color=always ./lorem.txt ./received/loremInput
