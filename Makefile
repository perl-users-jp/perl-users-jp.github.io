build:
	carton install && carton exec -- perl -Ilib script/build.pl
clean:
	rm -r public
test:
	carton install && carton exec -- prove -Ilib -r t
server:
	carton exec -- plackup -R public/ -p 5555 --host localhost -MPlack::App::Directory -e 'Plack::App::Directory->new({root => "public"})->to_app'
