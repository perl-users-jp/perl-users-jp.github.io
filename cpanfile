requires 'perl', '5.030001';

requires 'Class::Tiny';
requires 'Date::Format';
requires 'Path::Tiny';
requires 'Text::Xatena';
requires 'Text::Markdown';
requires 'Text::MicroTemplate';

on 'test' => sub {
    requires 'Test2::V0';
};
