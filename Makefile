build:
	carton install && carton exec -- perl -Ilib script/build.pl
clean:
	rm -r docs
test:
	carton install && carton exec -- prove -Ilib -r t
