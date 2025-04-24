{ pkgs }:
let

  lib = pkgs.lib;

  server = pkgs.runCommandLocal "server" { } ''
    ${pkgs.bun}/bin/bun build ${./server.ts} \
      --compile \
      --minify \
      --sourcemap \
      --outfile server
    mkdir -p $out/bin
    mv server $out/bin/server
  '';


  runTest = testFile: pkgs.runCommandLocal ""
    {
      buildInputs = [ pkgs.jq pkgs.netero-test server ];
    } ''
    mkdir ./var
    export NETERO_BROWSER_STATE_FILE="$PWD/var/browser-state.txt"
    printf "$PWD/var/lib/browser1" > "$PWD/var/browser-state.txt"
    mkdir -p ./var/lib/browser1
    mkdir -p ./run/netero
    mkfifo ./run/netero/ready.fifo
    mkfifo ./run/netero/exit.fifo

    server 2>&1 | while IFS= read -r line; do
      printf '\033[34m[server]\033[0m %s\n' "$line"
    done &
    server_pid=$!

    cat ./run/netero/ready.fifo >/dev/null

    echo "http://localhost:8080/" > "$PWD/var/lib/browser1/url.txt"

    bash -euo pipefail ${testFile} 2>&1 | while IFS= read -r line; do
      printf '\033[33m[client]\033[0m %s\n' "$line"
    done

    echo >./run/netero/exit.fifo
    wait $server_pid
    mkdir $out
  '';


  testFiles = {
    url = runTest ./url.sh;
    search-param = runTest ./search-param.sh;
  };

in
lib.mapAttrs'
  (name: value: {
    name = "goto-test-" + name;
    value = value.overrideAttrs (oldAttrs: {
      name = "goto-test-" + name;
    });
  })
  testFiles
