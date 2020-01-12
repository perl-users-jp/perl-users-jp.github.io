use Test2::V0;

use PerlUsersJP::Builder;
use Path::Tiny qw(path);

my $builder = PerlUsersJP::Builder->new(
    src_dir     => './src',
    docs_dir    => './docs',
    layouts_dir => './layouts',
);

subtest 'dest_dir' => sub {
    is $builder->dest_dir(path('src/foo/bar/text.md')), 'docs/foo/bar';
    is $builder->dest_dir(path('src/index.md')), 'docs';
};

subtest 'is_entry' => sub {
    ok $builder->is_entry(path('src/foo/bar/text.md'));
    ok $builder->is_entry(path('src/foo/bar/text.markdown'));
    ok $builder->is_entry(path('src/foo/bar/text.txt'));
    ok !$builder->is_entry(path('src/foo/bar/text.css'));
};

subtest 'detect_format' => sub {
    is $builder->detect_format(path('src/foo/bar/text.md')), 'markdown';
    is $builder->detect_format(path('src/foo/bar/text.markdown')), 'markdown';
    is $builder->detect_format(path('src/foo/bar/text.txt')), 'hatena';
    is $builder->detect_format(path('src/foo/bar/text.css')), undef;
};


done_testing;
