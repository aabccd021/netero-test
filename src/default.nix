{ pkgs }:
let

  basicScript =
    name: scriptPath:
    pkgs.writeShellApplication {
      name = name;
      text = builtins.readFile scriptPath;
      bashOptions = [
        "errexit"
        "nounset"
      ];
      extraShellCheckFlags = [
        "--shell"
        "sh"
      ];
      runtimeInputs = [
        pkgs.jq
        pkgs.curl
        pkgs.xidel
        pkgs.url-parser
      ];
    };

in

pkgs.symlinkJoin {
  name = "netero-test";
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
    (basicScript "assert_snapshot_equal_body" ./assert_snapshot_equal_body.sh)
    (basicScript "assert_starts_with" ./assert_starts_with.sh)
    (basicScript "assert_url_equal" ./assert_url_equal.sh)
    (basicScript "assert_url_length_equal" ./assert_url_length_equal.sh)
    (basicScript "assert_url_starts_with" ./assert_url_starts_with.sh)
    (basicScript "goto" ./goto.sh)
    (basicScript "submit" ./submit.sh)
    (basicScript "time_advance" ./time_advance.sh)
    (basicScript "netero_init" ./netero_init.sh)
    (basicScript "tab_switch" ./tab_switch.sh)
    (basicScript "browser_switch" ./browser_switch.sh)
    (basicScript "cookie_print" ./cookie_print.sh)
  ];
}
