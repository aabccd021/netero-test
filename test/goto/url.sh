goto --url "http://localhost:8080/hello/world"

printf "GET http://localhost:8080/hello/world" >./expected.txt
diff --unified --color=always ./expected.txt ./request.txt
