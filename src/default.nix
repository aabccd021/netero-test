{ pkgs }:
let

  basicScript =
    name: scriptPath:
    pkgs.writeShellApplication {
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
  name = "netero-test";
  paths = [
    (basicScript "assert-equal" ./assert-equal.sh)
    (basicScript "assert-header-equal" ./assert-header-equal.sh)
    (basicScript "assert-page-contains-text" ./assert-page-contains-text.sh)
    (basicScript "assert-query-returns-empty" ./assert-query-returns-empty.sh)
    (basicScript "assert-query-returns-equal" ./assert-query-returns-equal.sh)
    (basicScript "assert-query-returns-non-empty" ./assert-query-returns-non-empty.sh)
    (basicScript "assert-query-returns-with-line" ./assert-query-returns-with-line.sh)
    (basicScript "assert-response-code-equal" ./assert-response-code-equal.sh)
    (basicScript "assert-snapshot-equal" ./assert-snapshot-equal.sh)
    (basicScript "assert-snapshot-equal-body" ./assert-snapshot-equal-body.sh)
    (basicScript "assert-starts-with" ./assert-starts-with.sh)
    (basicScript "assert-url" ./assert-url.sh)
    (basicScript "goto" ./goto.sh)
    (basicScript "submit" ./submit.sh)
  ];
}
