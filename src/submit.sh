browser_state="$NETERO_STATE/browser/$(cat "$NETERO_STATE/active-browser.txt")"
tab_state="$browser_state/tab/$(cat "$NETERO_STATE/active-tab.txt")"
mkdir -p "$tab_state"

# Multiple files from single input is not supported
# -F 'file=@/path/to/your/file1.txt' \
# -F 'file=@/path/to/your/file2.jpg' \
validate_element() {
  el_type="$1"
  el_name="$2"
  el_html="$3"
  data_path="$4"

  attrnames=$(echo "$el_html" | xidel -e "//$el_type/@*/name()")

  if echo "$attrnames" | grep -q "\brequired\b" && [ -z "$data_path" ]; then
    echo "Error: Missing required $el_type: $el_name" >&2
    exit 1
  fi

  if echo "$attrnames" | grep -q "\bdisabled\b" && [ -n "$data_path" ]; then
    echo "Error: Disabled $el_type: $el_name" >&2
    exit 1
  fi

  if echo "$attrnames" | grep -q "\breadonly\b" && [ -n "$data_path" ]; then
    echo "Error: Readonly $el_type: $el_name" >&2
    exit 1
  fi
}

validate_text() {
  el_type="$1"
  el_name="$2"
  el_html="$3"
  data_path="$4"

  if [ ! -f "$data_path" ]; then
    echo "File not found for input: $el_name" >&2
    exit 1
  fi

  data=$(cat "$data_path")

  attrnames=$(echo "$el_html" | xidel -e "//$el_type/@*/name()")

  min_length=$(echo "$el_html" | xidel -e "//$el_type/@minlength")
  if [ -n "$min_length" ] && [ ${#data} -lt "$min_length" ]; then
    echo "Error: $el_type too short: $el_name" >&2
    echo "Min length: $min_length" >&2
    echo "Data length: ${#data}" >&2
    echo "Data path: $data_path" >&2
    echo "Data: $data" >&2
    exit 1
  fi

  max_length=$(echo "$el_html" | xidel -e "//$el_type/@maxlength")
  if [ -n "$max_length" ] && [ ${#data} -gt "$max_length" ]; then
    echo "Error: $el_type too long: $el_name" >&2
    echo "Max length: $max_length" >&2
    echo "Data length: ${#data}" >&2
    echo "Data path: $data_path" >&2
    echo "Data: $data" >&2
    exit 1
  fi

  if echo "$attrnames" | grep -q "\brequired\b" && [ -z "$data" ]; then
    echo "Error: Missing required $el_type: $el_name" >&2
    exit 1
  fi

}

form_query=${1:-}
shift

if [ -z "$form_query" ]; then
  echo "Usage: submit <query> [--submit-button <query>] [--data <name=value> ...]" >&2
  exit 1
fi

submit_button_query=""
data_str=""
while [ $# -gt 0 ]; do
  case $1 in
  --submit-button)
    submit_button_query=${2:-}
    shift
    ;;
  --data)
    data_str=$(printf "%s\n%s" "$data_str" "$2")
    shift
    ;;
  *)
    echo "Error: Unknown flag $1" >&2
    exit 1
    ;;
  esac
  shift
done

form_el=$(xidel "$tab_state/page.html" -e "$form_query" --html)
form_count=$(echo "$form_el" | xidel -e "count(//form)")
if [ "$form_count" -eq 0 ]; then
  echo "Error: Form not found" >&2
  echo "Query: $form_query" >&2
  exit 1
fi

if [ "$form_count" -gt 1 ]; then
  echo "Error: Multiple forms found." >&2
  echo "Please make the form query more specific." >&2
  exit 1
fi

form_id=$(echo "$form_el" | xidel -e '//form/@id')

action=$(echo "$form_el" | xidel -e '//form/@action')
if [ -z "$action" ] && [ -f "$tab_state/url.txt" ]; then
  action=$(cat "$tab_state/url.txt")
fi

if [ -z "$action" ]; then
  echo "Error: Missing action attribute in form" >&2
  echo "$form_el"
  exit 1
fi

curl_options=""

method=$(echo "$form_el" | xidel -e '//form/@method' | tr '[:upper:]' '[:lower:]')
if [ "$method" != "get" ] && [ "$method" != "post" ]; then
  method="get"
fi

enc_type=$(echo "$form_el" | xidel -e '//form/@enctype')
if [ "$enc_type" != "application/x-www-form-urlencoded" ] &&
  [ "$enc_type" != "multipart/form-data" ]; then
  enc_type="application/x-www-form-urlencoded"
fi
curl_options="$curl_options --header 'Content-Type: $enc_type'"

form_data=""

if [ -n "$submit_button_query" ]; then
  submit_button_el=$(xidel "$tab_state/page.html" -e "$submit_button_query" --html)
else
  submit_button_el_inside_form=$(echo "$form_el" | xidel -e "//form//button" --html)
  submit_button_el_outside_form=$(xidel "$tab_state/page.html" --html -e "//button[@form='$form_id']")
  submit_button_el="$submit_button_el_inside_form $submit_button_el_outside_form"
fi

submit_button_count=$(echo "$submit_button_el" | xidel -e "count(//button)")
if [ "$submit_button_count" -eq 0 ]; then
  echo "Error: Submit button not found" >&2
  exit 1
fi

# count all button that have name attribute, from submit_button_el
submit_button_count=$(echo "$submit_button_el" | xidel -e "count(//button[@name])")
if [ "$submit_button_count" -gt 1 ]; then
  echo "Error: Multiple submit buttons with 'name' attribute found." >&2
  echo "Please select one using the '--submit-button' option." >&2
  exit 1
fi

submit_button_name=$(echo "$submit_button_el" | xidel -e '//button/@name')
submit_button_value=$(echo "$submit_button_el" | xidel -e '//button/@value')
if [ -n "$submit_button_name" ]; then
  tmpfile=$(mktemp)
  printf "%s" "$submit_button_value" >"$tmpfile"
  form_data="$form_data $submit_button_name=<$tmpfile"
fi

# extract form data from button
input_els=$(echo "$form_el" | xidel -e '//form//input/@name')
for input_name in $input_els; do
  input_el=$(echo "$form_el" | xidel -e "//form//input[@name='$input_name']" --html)

  data_path=$(echo "$data_str" | grep "^$input_name=" | cut -d= -f2- || true)
  if [ -z "$data_path" ]; then
    # if value attribute exists
    attrnames=$(echo "$input_el" | xidel -e "//input/@*/name()")
    if echo "$attrnames" | grep -q "\bvalue\b"; then
      defaultValue=$(echo "$input_el" | xidel -e '//input/@value')
      tmpfile=$(mktemp)
      printf "%s" "$defaultValue" >"$tmpfile"
      data_path="$tmpfile"
    fi
  fi

  validate_element "input" "$input_name" "$input_el" "$data_path"

  input_type=$(echo "$input_el" | xidel -e '//input/@type' | uniq)
  if [ "$input_type" = "text" ] || [ "$input_type" = "password" ]; then
    validate_text "input" "$input_name" "$input_el" "$data_path"
    data="<$data_path"
  elif [ "$input_type" = "url" ] || [ "$input_type" = "email" ]; then
    echo "Warning: Input type '$input_type' is not fully validated." >&2
    validate_text "input" "$input_name" "$input_el" "$data_path"
    data="<$data_path"
  elif [ "$input_type" = "radio" ]; then
    valid_values=$(echo "$input_el" | xidel -e '//input[@type="radio"]/@value')
    data=""
    for value in $valid_values; do
      if [ "$value" = "$(cat "$data_path")" ]; then
        data="<$data_path"
        break
      fi
    done
    if [ -z "$data" ]; then
      echo "Error: Invalid radio value" >&2
      echo "Input name: $input_name" >&2
      echo >&2
      echo "Actual value:" >&2
      cat "$data_path" >&2
      echo >&2
      echo "Expected values:" >&2
      echo "$valid_values" >&2
      exit 1
    fi
  elif [ "$input_type" = "checkbox" ]; then
    if [ -n "$data_path" ]; then
      checkbox_value=$(cat "$data_path")
      if [ "$checkbox_value" = "true" ] || [ "$checkbox_value" = "1" ] || [ "$checkbox_value" = "yes" ]; then
        checkbox_val=$(echo "$input_el" | xidel -e '//input/@value')
        if [ -z "$checkbox_val" ]; then
          checkbox_val="on"
        fi
        tmpfile=$(mktemp)
        printf "%s" "$checkbox_val" >"$tmpfile"
        data="<$tmpfile"
        form_data="$form_data $input_name=$data"
      fi
    elif echo "$input_el" | xidel -e "//input/@*/name()" | grep -q "\bchecked\b"; then
      checkbox_val=$(echo "$input_el" | xidel -e '//input/@value')
      if [ -z "$checkbox_val" ]; then
        checkbox_val="on"
      fi
      tmpfile=$(mktemp)
      printf "%s" "$checkbox_val" >"$tmpfile"
      data="<$tmpfile"
      form_data="$form_data $input_name=$data"
    fi
    continue
  elif [ "$input_type" = "file" ]; then
    if [ "$enc_type" = "multipart/form-data" ]; then
      if [ -z "$data_path" ]; then
        data="@$(mktemp)"
      else
        data="@$data_path"
      fi
    else
      tmpfile=$(mktemp)
      printf "%s" "$data_path" >"$tmpfile"
      data="<$tmpfile"
    fi
  elif [ "$input_type" = "hidden" ]; then
    data="<$data_path"
  else
    echo "Error: Unsupported input type: $input_type" >&2
    exit 1
  fi

  form_data="$form_data $input_name=$data"

done

# extract form data from textarea
textarea_els=$(echo "$form_el" | xidel -e '//form//textarea/@name')
for textarea_name in $textarea_els; do
  textarea_el=$(echo "$form_el" | xidel -e "//form//textarea[@name='$textarea_name']" --html)

  data_path=$(echo "$data_str" | grep "^$textarea_name=" | cut -d= -f2- || true)
  if [ -z "$data_path" ]; then
    defaultValue=$(echo "$textarea_el" | xidel -e '//textarea')
    if [ -n "$defaultValue" ]; then
      tmpfile=$(mktemp)
      printf "%s" "$defaultValue" >"$tmpfile"
      data_path="$tmpfile"
    fi
  fi

  validate_element "textarea" "$textarea_name" "$textarea_el" "$data_path"
  validate_text "textarea" "$textarea_name" "$textarea_el" "$data_path"

  form_data="$form_data $textarea_name=<$data_path"

done

for data in $form_data; do
  key=$(echo "$data" | cut -d= -f1)
  value=$(echo "$data" | cut -d= -f2-)
  if [ "$enc_type" = "multipart/form-data" ] && echo "$value" | grep -q "^@"; then
    curl_options="$curl_options --form '$data'"
    continue
  fi

  filepath=$(echo "$value" | cut -c 2-)
  value=$(cat "$filepath")
  nl_value=$(printf "%s" "$value" | wc -l)
  nl_file=$(wc -l "$filepath" | cut -d' ' -f1)
  nl_diff=$((nl_file - nl_value))
  nls=""
  while [ "$nl_diff" -gt 0 ]; do
    nls="$nls
"
    nl_diff=$((nl_diff - 1))
  done
  value="$value$nls"

  if [ "$method" = "get" ] || [ "$enc_type" = "application/x-www-form-urlencoded" ]; then
    value=$(printf "%s" "$value" | jq -sRr @uri)
    curl_options="$curl_options --data $key=$value"
  elif [ "$enc_type" = "multipart/form-data" ]; then
    curl_options="$curl_options --form-string '$key=$value'"
  fi
done

if [ -z "$form_data" ]; then
  curl_options="$curl_options --data-raw ''"
elif [ "$method" = "get" ] || [ -z "$method" ]; then
  curl_options="$curl_options --get"
fi

curl_options="$curl_options \
  --cookie $browser_state/cookie.txt \
  --cookie-jar $browser_state/cookie.txt \
  --output $tab_state/body \
  --write-out '%output{$tab_state/url.txt}%{url_effective}%output{$tab_state/headers.json}%{header_json}%output{$tab_state/response.json}%{json}' \
  --compressed \
  --show-error \
  --silent \
  --location \
"

url="$action"

if [ -f "$tab_state/url.txt" ]; then
  current_url=$(cat "$tab_state/url.txt")
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

content_type=$(jq -r '.["content-type"][0]' "$tab_state/headers.json")
if [ "$content_type" = "text/html" ]; then
  mv "$tab_state/body" "$tab_state/page.html"
elif [ -f "$tab_state/page.html" ]; then
  rm "$tab_state/page.html"
fi
