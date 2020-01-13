use strict;
use warnings;
use PerlUsersJP::Builder;

PerlUsersJP::Builder->new(
    content_dir => './content',
    public_dir  => './public',
    layouts_dir => './layouts',
)->run;
