build:
	cpm install && perl -Ilocal/lib/perl5 -Ilib script/build.pl
clean:
	rm -r public
test:
	cpm install && prove -Ilocal/lib/perl5 -Ilib -r t
server: build
	plackup -Ilocal/lib/perl5 -p 5555 --host localhost script/app.psgi
