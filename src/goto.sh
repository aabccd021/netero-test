url=""
anchor_href=""
anchor_href_with_text=""
anchor_href_with_aria_label=""
img_src=""
img_src_with_alt=""
while [ $# -gt 0 ]; do
  case $1 in
  --url)
    url=$2
    shift
    ;;
  --reload)
    if [ -f "$NETERO_STATE/url.txt" ]; then
      url=$(cat "$NETERO_STATE/url.txt")
    else
      echo "Error: No url to reload" >&2
      exit 1
    fi
    ;;
  --anchor-href)
    anchor_href=$2
    shift
    ;;
  --anchor-href-with-text)
    anchor_href_with_text=$2
    shift
    ;;
  --anchor-href-with-aria-label)
    anchor_href_with_aria_label=$2
    shift
    ;;
  --img-src)
    img_src=$2
    shift
    ;;
  --img-src-with-alt)
    img_src_with_alt=$2
    shift
    ;;
  *)
    echo "Error: Unknown flag: $1" >&2
    exit 1
    ;;
  esac
  shift
done

mkdir -p "$NETERO_STATE"

if [ -n "$anchor_href" ]; then

  if [ ! -f "$NETERO_STATE/page.html" ]; then
    echo "Error: No page.html found" >&2
    exit 1
  fi

  returned_urls=$(xidel "$NETERO_STATE/page.html" -e "//a/@href")

  url=""
  for returned_url in $returned_urls; do
    if [ "$anchor_href" = "$returned_url" ]; then
      url="$anchor_href"
      break
    fi
  done

  if [ -z "$url" ]; then
    echo "Error: Anchor with href '$anchor_href' not found" >&2
    echo
    echo "Available anchor hrefs:"
    echo "$returned_urls"
    exit 1
  fi

elif [ -n "$anchor_href_with_text" ]; then
  if [ ! -f "$NETERO_STATE/page.html" ]; then
    echo "Error: No page.html found" >&2
    exit 1
  fi
  texts=$(xidel "$NETERO_STATE/page.html" -e "//a/text()")

  a_el=""
  while IFS= read -r text; do
    if [ "$anchor_href_with_text" = "$text" ]; then
      a_el=$(xidel "$NETERO_STATE/page.html" --html -e "//a[text()='$anchor_href_with_text']")
      break
    fi
  done <<EOF
$texts
EOF

  if [ -z "$a_el" ]; then
    echo "Error: Anchor with text '$anchor_href_with_text' not found" >&2
    echo
    echo "Available anchor texts:"
    echo "$texts"
    exit 1
  fi

  url=$(echo "$a_el" | xidel -e "//a/@href")
  if [ -z "$url" ]; then
    echo "Error: Anchor with text '$anchor_href_with_text' has no href" >&2
    echo "$a_el"
    exit 1
  fi

elif [ -n "$anchor_href_with_aria_label" ]; then

  if [ ! -f "$NETERO_STATE/page.html" ]; then
    echo "Error: No page.html found" >&2
    exit 1
  fi

  aria_labels=$(xidel "$NETERO_STATE/page.html" -e "//a/@aria-label")

  a_el=""
  while IFS= read -r aria_label; do
    if [ "$anchor_href_with_aria_label" = "$aria_label" ]; then
      a_el=$(xidel "$NETERO_STATE/page.html" --html -e "//a[@aria-label='$anchor_href_with_aria_label']")
      break
    fi
  done <<EOF
$aria_labels
EOF

  if [ -z "$a_el" ]; then
    echo "Error: Anchor with aria-label '$anchor_href_with_aria_label' not found" >&2
    echo
    echo "Available anchor aria-labels:"
    echo "$aria_labels"
    exit 1
  fi

  url=$(echo "$a_el" | xidel -e "//a/@href")
  if [ -z "$url" ]; then
    echo "Error: Anchor with aria-label '$anchor_href_with_aria_label' has no href" >&2
    echo "$a_el"
    exit 1
  fi

elif [ -n "$img_src" ]; then

  if [ ! -f "$NETERO_STATE/page.html" ]; then
    echo "Error: No page.html found" >&2
    exit 1
  fi

  returned_srcs=$(xidel "$NETERO_STATE/page.html" -e "//img/@src")

  url=""
  for returned_src in $returned_srcs; do
    if [ "$img_src" = "$returned_src" ]; then
      url="$img_src"
      break
    fi
  done

  if [ -z "$url" ]; then
    echo "Error: Image with src '$img_src' not found" >&2
    echo
    echo "Available image srcs:"
    echo "$returned_srcs"
    exit 1
  fi

elif [ -n "$img_src_with_alt" ]; then

  if [ ! -f "$NETERO_STATE/page.html" ]; then
    echo "Error: No page.html found" >&2
    exit 1
  fi

  alts=$(xidel "$NETERO_STATE/page.html" -e "//img/@alt")

  img_el=""
  while IFS= read -r alt; do
    if [ "$img_src_with_alt" = "$alt" ]; then
      img_el=$(xidel "$NETERO_STATE/page.html" --html -e "//img[@alt='$img_src_with_alt']")
      break
    fi
  done <<EOF
$alts
EOF

  if [ -z "$img_el" ]; then
    echo "Error: Image with alt '$img_src_with_alt' not found" >&2
    echo
    echo "Available image alts:"
    echo "$alts"
    exit 1
  fi

  url=$(echo "$img_el" | xidel -e "//img/@src")
  if [ -z "$url" ]; then
    echo "Error: Image with alt '$img_src_with_alt' has no src" >&2
    echo "$img_el"
    exit 1
  fi

fi

curl_options=" \
  --cookie $NETERO_STATE/cookie.txt \
  --cookie-jar $NETERO_STATE/cookie.txt \
  --output $NETERO_STATE/body \
  --write-out \"%output{$NETERO_STATE/url.txt}%{url_effective}%output{$NETERO_STATE/headers.json}%{header_json}%output{$NETERO_STATE/response.json}%{json}\" \
  --compressed \
  --show-error \
  --silent \
  --location \
"

if [ -f "$NETERO_STATE/url.txt" ]; then
  current_url=$(cat "$NETERO_STATE/url.txt")
  current_host=$(echo "$current_url" | cut -d/ -f1-3)
  curl_options="$curl_options \
    --referer '$current_url' \
    --header 'Origin: $current_host' \
  "

  if echo "$url" | grep -q "^/"; then
    url="$current_host$url"
  fi

fi

eval "curl $curl_options '$url'"

content_type=$(jq -r '.["content-type"][0]' "$NETERO_STATE/headers.json")
if [ "$content_type" = "text/html" ]; then
  mv "$NETERO_STATE/body" "$NETERO_STATE/page.html"
elif [ -f "$NETERO_STATE/page.html" ]; then
  rm "$NETERO_STATE/page.html"
fi
