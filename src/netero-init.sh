mkdir -p "$NETERO_STATE/browser/1/tab/1"

if [ ! -f "$NETERO_STATE/active-browser.txt" ]; then
  printf "1" >"$NETERO_STATE/active-browser.txt"
fi

if [ ! -f "$NETERO_STATE/active-tab.txt" ]; then
  printf "1" >"$NETERO_STATE/active-tab.txt"
fi
