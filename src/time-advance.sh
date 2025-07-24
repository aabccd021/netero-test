time_now=$(cat "$NETERO_STATE/now.txt")
time_advanced=$(date --utc --date "$time_now +$1" +"%Y-%m-%dT%H:%M:%SZ")
printf "%s" "$time_advanced" >"$NETERO_STATE/now.txt"
