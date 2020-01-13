build:
	carton install && carton exec -- perl -Ilib script/build.pl
clean:
	rm -r public
test:
	carton install && carton exec -- prove -Ilib -r t
