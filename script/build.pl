use strict;
use warnings;
use PerlUsersJP::Builder;

PerlUsersJP::Builder->new(
    src_dir     => './src',
    docs_dir    => './docs',
    layouts_dir => './layouts',
)->run;
