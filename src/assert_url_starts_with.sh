prefix=${1:-}

if [ -z "$prefix" ]; then
  echo "Usage: assert_url_starts_with <prefix>"
  exit 1
fi

actual="$(cat "$NETERO_DIR/url.txt")"

case "$actual" in
"$prefix"*)
  exit 0
  ;;
*)
  echo "Assertion error: string does not start with prefix"
  echo
  echo "prefix expected:"
  echo "$prefix"
  echo
  echo "string:"
  echo "$actual"
  exit 1
  ;;
esac
