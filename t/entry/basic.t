use Test2::V0;

use PerlUsersJP::Entry;

subtest 'parse_meta' => sub {
    my $raw_meta = <<~ "...";
    some title
    meta-author: some author
    meta-description: some description
    ...

    is PerlUsersJP::Entry::_parse_meta($raw_meta), {
        title       => 'some title',
        author      => 'some author',
        description => 'some description',
    };
};

done_testing;
