browser_idx="$(cat "$NETERO_STATE/active-browser.txt")"
cat "$NETERO_STATE/browser/$browser_idx/cookie.txt"
