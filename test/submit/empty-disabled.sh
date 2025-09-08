cat >"$NETERO_STATE/page.html" <<EOF
<form action="/form" method="post">
  <input type="text" name="loremInput" value="foo" disabled>
  <button type="submit">Submit</button>
</form>
EOF

submit "//form"

if [ -f ./received/loremInput ]; then
  echo "Error: Expected no submission, but received/loremInput exists"
  exit 1
fi
