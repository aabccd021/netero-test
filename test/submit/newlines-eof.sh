browser_state=$(cat "$NETERO_BROWSER_STATE_FILE")

cat >"$browser_state/page.html" <<EOF
<form action="/form" method="post">
  <input type="text" name="loremInput">
  <button type="submit">Submit</button>
</form>
EOF

cat >lorem.txt <<EOF
foo
bar
baz
EOF
submit "//form" --data "loremInput=lorem.txt"

diff --unified --color=always ./lorem.txt ./received/loremInput
