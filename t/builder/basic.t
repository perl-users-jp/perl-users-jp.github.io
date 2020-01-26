use Test2::V0;

use PerlUsersJP::Builder;
use Path::Tiny qw(path);

my $builder = PerlUsersJP::Builder->new(
    content_dir => './content',
    public_dir  => './public',
    layouts_dir => './layouts',
);

subtest 'to_public' => sub {
    is $builder->to_public(path('content/foo/bar/text.md')), 'public/foo/bar/text.md';
    is $builder->to_public(path('content/index.md')), 'public/index.md';
};


done_testing;
