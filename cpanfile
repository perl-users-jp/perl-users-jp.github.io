requires 'perl', '5.030001';

# order by a-z
requires 'Class::Tiny';
requires 'Date::Format';
requires 'Encode';
requires 'Encode::Locale';
requires 'Path::Tiny';
requires 'Pod::Simple::XHTML';
requires 'Text::Markdown';
requires 'Text::MicroTemplate';
requires 'Text::Xatena';
requires 'URI::Escape';
requires 'XML::Atom';

on 'develop' => sub {
    requires 'Plack';
};

on 'test' => sub {
    requires 'Test2::V0';
};
