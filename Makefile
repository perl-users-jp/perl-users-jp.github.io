build:
	carton install && carton exec -- perl -Ilib script/build.pl
clean:
	rm -r public
test:
	carton install && carton exec -- prove -Ilib -r t
server: build
	carton exec -- plackup -R public/ -p 5555 --host localhost script/app.psgi
