prefix=${1:-}
actual=${2:-}

if [ -z "$prefix" ] || [ -z "$actual" ]; then
  echo "Usage: assert_starts_with <prefix> <actual>"
  exit 1
fi

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
