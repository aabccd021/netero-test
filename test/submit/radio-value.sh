cat >"$NETERO_STATE/page.html" <<EOF
<form action="/form" method="post">
  <input type="radio" name="theme" value="dark">
  <input type="radio" name="theme" value="light">
  <button type="submit">Submit</button>
</form>
EOF

printf "system" >theme.txt
submit "//form" --data "theme=theme.txt" 2>actual.txt || err_code=$?

if [ "$err_code" -ne 1 ]; then
  echo "Error: Expected exit code 1, got $err_code"
  cat actual.txt
  exit 1
fi

cat >expected.txt <<EOF
Error: Invalid radio value
Input name: theme

Actual value:
system
Expected values:
dark
light
EOF

diff --unified --color=always expected.txt actual.txt
