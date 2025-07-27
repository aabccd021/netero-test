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

  lib = pkgs.runCommand "netero-test-lib" { } ''
    mkdir --parent "$out/lib"
    ${pkgs.gcc_multi}/bin/gcc -shared -fPIC -o "$out/lib/libmocktime.so" ${./mocktime.c} -ldl
  '';

in

pkgs.symlinkJoin {
  name = "netero-test";
  paths = [
    lib
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
    (basicScript "time-advance" ./time-advance.sh)
    (basicScript "netero-init" ./netero-init.sh)
    (basicScript "tab-switch" ./tab-switch.sh)
    (basicScript "browser-switch" ./browser-switch.sh)
    (basicScript "cookie-print" ./cookie-print.sh)
  ];
}
