browser_state="$NETERO_STATE/browser/1"
tab_state="$browser_state/tab/1"

cat >"$tab_state/page.html" <<EOF
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
