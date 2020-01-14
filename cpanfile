requires 'perl', '5.030001';

requires 'Class::Tiny';
requires 'Date::Format';
requires 'Path::Tiny';
requires 'Text::MicroTemplate';

requires 'Text::Xatena';
requires 'Text::Markdown';
requires 'Pod::Simple::XHTML';

on 'test' => sub {
    requires 'Test2::V0';
};
