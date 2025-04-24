browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"

cat >"$tab_state/page.html" <<EOF
<form action="/form" method="post" id="myForm">
  <input type="text" name="loremInput">
  <button name="buttonValue" value="netero">Submit foo</button>
</form>
<button form="myForm" name="buttonValue" value="meruem">Submit bar</button>
EOF

printf "foo" >lorem.txt
submit "//form" --data "loremInput=lorem.txt" --submit-button "//form/button"

printf "netero" >button-value.txt

diff --unified --color=always ./lorem.txt ./received/loremInput
diff --unified --color=always ./button-value.txt ./received/buttonValue
