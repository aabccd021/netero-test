goto --url "http://localhost:8080/hello/world?search=param&foo=bar"

printf "GET http://localhost:8080/hello/world?search=param&foo=bar" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt
