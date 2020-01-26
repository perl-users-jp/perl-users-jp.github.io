use Test2::V0;

use PerlUsersJP::FrontMatter;

subtest 'parse_meta' => sub {
    my $raw_meta = <<~ "...";
    some title
    meta-author: some author
    meta-description: some description
    ...

    is PerlUsersJP::FrontMatter::_parse_meta($raw_meta), {
        title       => 'some title',
        author      => 'some author',
        description => 'some description',
    };
};

subtest 'detect_entry_format' => sub {
    is(PerlUsersJP::FrontMatter::_detect_entry_format('src/foo/bar/text.md'), 'markdown');
    is(PerlUsersJP::FrontMatter::_detect_entry_format('src/foo/bar/text.markdown'), 'markdown');
    is(PerlUsersJP::FrontMatter::_detect_entry_format('src/foo/bar/text.txt'), 'hatena');
    is(PerlUsersJP::FrontMatter::_detect_entry_format('src/foo/bar/text.css'), undef);
};


done_testing;
