{ pkgs }:
let

  lib = pkgs.lib;

  serverTest =
    serverSrc: testFile:
    let
      server = pkgs.runCommandLocal "server" { } ''
        ${pkgs.bun}/bin/bun build ${serverSrc} \
          --compile \
          --minify \
          --sourcemap \
          --outfile server
        mkdir -p $out/bin
        mv server $out/bin/server
      '';
    in
    pkgs.runCommandLocal ""
      {
        buildInputs = [
          pkgs.jq
          pkgs.netero-test
          server
        ];
      }
      ''
        mkdir ./var
        export NETERO_STATE="$PWD/var/netero"
        netero-init
        mkfifo ./ready.fifo
        mkfifo ./exit.fifo

        server 2>&1 | while IFS= read -r line; do
          printf '\033[34m[server]\033[0m %s\n' "$line"
        done &
        server_pid=$!

        cat ./ready.fifo >/dev/null

        echo "http://localhost:8080/" > "$PWD/var/netero/browser/1/tab/1/url.txt"

        bash -euo pipefail ${testFile} 2>&1 | while IFS= read -r line; do
          printf '\033[33m[client]\033[0m %s\n' "$line"
        done

        echo >./exit.fifo
        wait $server_pid
        mkdir $out
      '';

  test =
    testFile:
    pkgs.runCommandLocal ""
      {
        buildInputs = [
          pkgs.netero-test
          pkgs.jq
        ];
      }
      ''
        mkdir ./var
        export NETERO_STATE="$PWD/var/netero"
        netero-init

        bash -euo pipefail ${testFile} 2>&1 | while IFS= read -r line; do
          printf '\033[33m[client]\033[0m %s\n' "$line"
        done
        mkdir $out
      '';

  testFiles = {
    button-outside-form = serverTest ./server.ts ./button-outside-form.sh;
    default-value = serverTest ./server.ts ./default-value.sh;
    disabled = test ./disabled.sh;
    file = serverTest ./server.ts ./file.sh;
    file-not-found = test ./file-not-found.sh;
    form-not-found = test ./form-not-found.sh;
    get = serverTest ./server.ts ./get.sh;
    get-search-param = serverTest ./server.ts ./get-search-param.sh;
    hidden = serverTest ./server.ts ./hidden.sh;
    maxlength = test ./maxlength.sh;
    minlength = test ./minlength.sh;
    newlines = serverTest ./server.ts ./newlines.sh;
    newlines-eof = serverTest ./server.ts ./newlines-eof.sh;
    newlines-multipart = serverTest ./server.ts ./newlines-multipart.sh;
    no-action = serverTest ./server.ts ./no-action.sh;
    no-button = test ./no-button.sh;
    no-button-type = serverTest ./server.ts ./no-button-type.sh;
    non-multipart-cant-submit-file = serverTest ./server.ts ./non-multipart-cant-submit-file.sh;
    radio = serverTest ./server.ts ./radio.sh;
    radio-value = test ./radio-value.sh;
    readonly = test ./readonly.sh;
    redirect-301 = serverTest ./server-redirect.ts ./redirect-301.sh;
    redirect-302 = serverTest ./server-redirect.ts ./redirect-302.sh;
    redirect-303 = serverTest ./server-redirect.ts ./redirect-303.sh;
    get-redirect-301 = serverTest ./server-redirect.ts ./get-redirect-301.sh;
    get-redirect-302 = serverTest ./server-redirect.ts ./get-redirect-302.sh;
    get-redirect-303 = serverTest ./server-redirect.ts ./get-redirect-303.sh;
    multipart-redirect-301 = serverTest ./server-redirect.ts ./multipart-redirect-301.sh;
    multipart-redirect-302 = serverTest ./server-redirect.ts ./multipart-redirect-302.sh;
    multipart-redirect-303 = serverTest ./server-redirect.ts ./multipart-redirect-303.sh;
    required = test ./required.sh;
    required-empty-string = test ./required-empty-string.sh;
    required-file-not-found = test ./required-file-not-found.sh;
    search-param = serverTest ./server.ts ./search-param.sh;
    sends-empty-file = serverTest ./server.ts ./sends-empty-file.sh;
    submit = serverTest ./server.ts ./submit.sh;
    submit-button-not-found = test ./submit-button-not-found.sh;
    textarea-maxlength = test ./textarea-maxlength.sh;
    textarea-minlength = test ./textarea-minlength.sh;
    two-form-no-button = test ./two-form-no-button.sh;
    two-forms = test ./two-forms.sh;
    two-submit-button-in-in = serverTest ./server.ts ./two-submit-button-in-in.sh;
    two-submit-button-in-out = serverTest ./server.ts ./two-submit-button-in-out.sh;
    two-submit-button-value-in-in = test ./two-submit-button-value-in-in.sh;
    two-submit-button-value-in-out = test ./two-submit-button-value-in-out.sh;
    two-submit-button-value-in-out-select-in = serverTest ./server.ts ./two-submit-button-value-in-out-select-in.sh;
    two-submit-button-value-in-out-select-out = serverTest ./server.ts ./two-submit-button-value-in-out-select-out.sh;
    unsupported-enctype = serverTest ./server.ts ./unsupported-enctype.sh;
    unsupported-method = serverTest ./server.ts ./unsupported-method.sh;
  };

in
lib.mapAttrs' (name: value: {
  name = "submit-test-" + name;
  value = value.overrideAttrs (oldAttrs: {
    name = "submit-test-" + name;
  });
}) testFiles
