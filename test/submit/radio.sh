browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

cat >"$tab_state/page.html" <<EOF
<form action="/form" method="post">
  <input type="radio" name="theme" value="dark">
  <input type="radio" name="theme" value="light">
  <button type="submit">Submit</button>
</form>
EOF

printf "dark" >theme.txt
submit "//form" --data "theme=theme.txt"

diff --unified --color=always ./theme.txt ./received/theme
