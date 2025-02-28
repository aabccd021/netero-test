cat >"$NETERO_DIR/page.html" <<EOF
<div></div>
EOF

submit "//form" 2>actual.txt || err_code=$?

if [ "$err_code" -ne 1 ]; then
  echo "Error: Expected exit code 1, got $err_code"
  exit 1
fi

echo "Error: Form not found" >expected.txt
echo "Query: //form" >>expected.txt
diff --unified --color=always expected.txt actual.txt
