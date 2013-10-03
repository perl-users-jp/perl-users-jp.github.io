all:
	cd Pujp && ./script/build.sh

dynamic:
	cd Pujp && carton install && carton exec perl script/pujp-server

static:
	plackup -p 5555 -MPlack::App::Directory -e 'Plack::App::Directory->new({root => "static"})->to_app'

test:
	cd Pujp && carton install && carton exec prove -lr t

