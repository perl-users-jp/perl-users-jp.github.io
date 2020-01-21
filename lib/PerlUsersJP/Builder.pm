package PerlUsersJP::Builder;
use strict;
use warnings;
use utf8;
use feature qw(state);

use PerlUsersJP::FrontMatter;

use Path::Tiny ();
use Date::Format ();
use Text::MicroTemplate;

use Text::Xatena;
use Text::Xatena::Inline;
use Text::Markdown;
use Pod::Simple::XHTML;

use Class::Tiny qw(
    content_dir
    public_dir
    layouts_dir
);

sub BUILDARGS {
    my ($class, %args) = @_;

    die "required 'content_dir'" unless exists $args{content_dir};
    die "required 'public_dir'"  unless exists $args{public_dir};
    die "required 'layouts_dir'" unless exists $args{layouts_dir};

    return {
        content_dir => ref $args{content_dir} ? $args{content_dir} : Path::Tiny::path($args{content_dir}),
        public_dir  => ref $args{public_dir}  ? $args{public_dir}  : Path::Tiny::path($args{public_dir}),
        layouts_dir => ref $args{layouts_dir} ? $args{layouts_dir} : Path::Tiny::path($args{layouts_dir}),
    }
}


sub run {
    my ($self) = @_;

    my (@entries, @static);
    my $iter = $self->content_dir->iterator({ recurse => 1 });
    while (my $src = $iter->()) {
        next unless $src->is_file;
        push @entries => $src if $self->is_entry($src);
        push @static  => $src if $self->is_static($src);
    }

    $self->diag("Build Start\n");
    $self->build_static(\@static);
    $self->build_entries(\@entries);
    $self->diag("Build Finished\n");
}

sub build_static {
    my ($self, $src_list) = @_;
    for my $src ($src_list->@*) {

        my $public_dir = $self->to_public($src->parent);
        $public_dir->mkpath if !$public_dir->is_dir;

        my $dest = $src->copy($public_dir);
        $self->diag("Created static $dest\n");
    }
}

sub build_entries {
    my ($self, $src_list) = @_;

    for my $src ($src_list->@*) {
        $self->build_entry($src);
    }

    $self->build_categories($src_list);
    # TODO
    #$self->build_tags(\@entries);
    #$self->build_sitemap(\@entries);
    #$self->build_atom(\@entries);
}

sub build_entry {
    my ($self, $src) = @_;

    my $matter = $self->front_matter($src);

    my $html = $self->_render_string('entry.html', {
        text        => $self->entry_text($src),
        title       => $matter->title,
        subtitle    => $self->entry_subtitle($src),
        author      => $matter->author,
        description => $matter->description,
    });

    my $name = $src->basename =~ s!\.[^.]+$!.html!r;
    my $dest = $self->to_public($src->parent)->child($name);
    $dest->spew_utf8($html);

    $self->diag("Created entry $dest\n");
}

sub entry_text {
    my ($self, $src) = @_;
    my $matter = $self->front_matter($src);
    my $format = $matter->format // $self->detect_format($src);
    my $text   = $self->format_text($matter->body, $format);
    return $text;
}

sub entry_subtitle {
    my ($self, $src) = @_;

    my $content_dir = $self->content_dir;
    my $parent      = $src->parent;

    my $subtitle;
    if ($parent eq $content_dir) {
        $subtitle = ""
    }
    else {
        # src/perl-advent-calendar/2012/casual
        # => Perl Advent Calendar 2012 Casual
        my @match = $parent =~ m!\w+!g;
        shift @match; # remove $content_dir
        $subtitle = join(' ', map { ucfirst } @match);
    }
    return $subtitle;
}



sub build_categories {
    my ($self, $src_list) = @_;

    my %src_list_map;
    for my $src ($src_list->@*) {
        my $category = $src->parent;
        while ($category ne $self->content_dir) {
            $src_list_map{$category}{$src} = 1;
            $src      = $category;
            $category = $src->parent;
        }
    }

    for my $category (keys %src_list_map) {
        my @src_list = keys $src_list_map{$category}->%*;
        $self->build_category($category, \@src_list);
    }
}

sub build_category {
    my ($self, $src_category, $src_list) = @_;

    my $content_dir = $self->content_dir;
    my $category = $src_category =~ s!$content_dir!!r;

    my $html = $self->_render_string('category.html', {
        category    => $category,
        description => "",
        title       => '',
        files       => [map {
            my $matter = $self->front_matter($_);
            my $title  = $matter->exists ? $matter->title : $_;
            my $href   = ""; # TODO
            { title => $title, href => $href }
        } $src_list->@* ],
    });

    my $category_dir = $self->public_dir->child($category);
    my $dest = $category_dir->child('index.html');
    $category_dir->mkpath;
    $dest->spew_utf8($html);
    $self->diag("Created category $dest\n");
}

sub category_title {
    my ($self, $entries) = @_;
}

sub category_description {
    my ($self, $entries) = @_;
}

sub build_tags {
    my ($self, $entries) = @_;
    ... # TODO
}

sub build_sitemap {
    my ($self, $entries) = @_;
    ... # TODO
}

sub build_atom {
    my ($self, $entries) = @_;
    ... # TODO
}

sub diag {
    my ($self, $msg) = @_;
    print $msg;
}

sub to_public {
    my ($self, $src) = @_;
    my $content_dir = $self->content_dir;
    my $dir         = $src =~ s!^$content_dir!!r;
    my $public      = $dir ? $self->public_dir->child($dir) : $self->public_dir;
    return $public
}

sub front_matter {
    my ($self, $src) = @_;
    return $self->{front_matter}{$src} //= do {
        PerlUsersJP::FrontMatter->new($src)
    }
}

sub is_entry {
    my ($self, $src) = @_;
    $self->front_matter($src)->exists
}

sub is_static {
    my ($self, $src) = @_;
    return !$self->is_entry($src)
}

sub format_text {
    my ($self, $text, $format) = @_;

    if ($format eq 'markdown') {
        return Text::Markdown::markdown($text);
    }
    elsif ($format eq 'hatena') {
        state $xatena = Text::Xatena->new;
        my $inline    = Text::Xatena::Inline->new;
        my $html = $xatena->format( $text, inline => $inline );
        $html .= join "\n", @{ $inline->footnotes };
        return $html;
    }
    elsif ($format eq 'pod') {
        my $parser = Pod::Simple::XHTML->new();
        $parser->output_string(\my $out);
        $parser->html_header('');
        $parser->html_footer('');
        $parser->parse_string_document("=pod\n\n$text");
    }
    else {
        die "unsupported format: $format";
    }
}

sub _render_string {
    my ($self, $template, $vars) = @_;

    $template = ref $template ? $template->slurp_utf8
              : $self->layouts_dir->child($template)->slurp_utf8;

    my $mt = Text::MicroTemplate->new(
        template    => $template,
        escape_func => sub { $_[0] }, # unescape text
    );
    my $code = $mt->code;
    my $renderer = eval <<~ "..." or die $@;
    sub {
        my \$vars = shift;
        $code->();
    }
    ...

    return $renderer->($vars);
}

1;
