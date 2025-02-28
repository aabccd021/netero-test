time_to_advance=${1:-}

if [ -z "$time_to_advance" ]; then
  echo "Usage: advance_time <time_to_advance>"
  exit 1
fi

time_now=$(cat "$NETERO_DIR/now_iso.txt")
time_advanced=$(date -u -d "$time_now +$time_to_advance" +"%Y-%m-%dT%H:%M:%SZ")
printf "%s" "$time_advanced" >"$NETERO_DIR/now_iso.txt"
