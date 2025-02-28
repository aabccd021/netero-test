{ pkgs }:
let

  basicScript = name: scriptPath: pkgs.writeShellApplication {
    name = name;
    text = builtins.readFile scriptPath;
    runtimeInputs = [
      pkgs.jq
      pkgs.curl
      pkgs.xidel
    ];
  };

in

pkgs.symlinkJoin {
  name = "posix-browser";
  paths = [
    (basicScript "assert_equal" ./assert_equal.sh)
    (basicScript "assert_header_equal" ./assert_header_equal.sh)
    (basicScript "assert_page_contains_text" ./assert_page_contains_text.sh)
    (basicScript "assert_query_returns_empty" ./assert_query_returns_empty.sh)
    (basicScript "assert_query_returns_equal" ./assert_query_returns_equal.sh)
    (basicScript "assert_query_returns_non_empty" ./assert_query_returns_non_empty.sh)
    (basicScript "assert_query_returns_with_line" ./assert_query_returns_with_line.sh)
    (basicScript "assert_response_code_equal" ./assert_response_code_equal.sh)
    (basicScript "assert_snapshot_equal" ./assert_snapshot_equal.sh)
    (basicScript "assert_starts_with" ./assert_starts_with.sh)
    (basicScript "assert_url_equal" ./assert_url_equal.sh)
    (basicScript "assert_url_length_equal" ./assert_url_length_equal.sh)
    (basicScript "assert_url_starts_with" ./assert_url_starts_with.sh)
    (basicScript "advance_time" ./advance_time.sh)
    (basicScript "goto" ./goto.sh)
    (basicScript "submit" ./submit.sh)
  ];
}
