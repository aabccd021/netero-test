browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

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
