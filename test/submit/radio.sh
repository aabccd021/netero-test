NETERO_DIR=$(cat "$NETERO_BROWSER_STATE_FILE")

cat >"$NETERO_DIR/page.html" <<EOF
<form action="/form" method="post">
  <input type="radio" name="theme" value="dark">
  <input type="radio" name="theme" value="light">
  <button type="submit">Submit</button>
</form>
EOF

printf "dark" >theme.txt
submit "//form" --data "theme=theme.txt"

diff --unified --color=always ./theme.txt ./received/theme
