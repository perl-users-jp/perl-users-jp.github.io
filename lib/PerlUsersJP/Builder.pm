package PerlUsersJP::Builder;
use strict;
use warnings;
use utf8;
use feature qw(state);

use PerlUsersJP::FrontMatter;

use Path::Tiny ();
use Date::Format ();
use Scalar::Util ();
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
    $self->build_tags($src_list);
    #$self->build_sitemap(\@entries);
    #$self->build_atom(\@entries);
}


# ビルドのルールは次の通り
#
# CASE1: content/foo/index.(md|html) から public/foo/index.html をビルド
# この時、URL pathは次の3種で、一番上をcanonial属性に指定する
#      /foo/
#      /foo/index.html
#      /foo
#
# CASE2: content/foo/bar.(md|html) から次の２つをビルド
#      1. public/foo/bar/index.html
#      2. public/foo/bar.html
# この時、URL pathは次の4種で、一番上をcanonial属性に指定する
#      /foo/bar
#      /foo/bar/
#      /foo/bar/index.html
#      /foo/bar.html
#
sub build_entry {
    my ($self, $src) = @_;

    my $matter = $self->front_matter($src);

    my $name = $src->basename =~ s!\.([^.]+)$!!r;
    my $dest_dir = $self->to_public($src->parent);
    $dest_dir = $dest_dir->child($name) unless $name eq 'index';
    $dest_dir->mkpath;
    my $dest = $dest_dir->child('index.html');
    my $sub_dest; $sub_dest = $dest->parent->parent->child("$name.html") unless $name eq 'index';

    if ($matter->format eq 'html') {
        $src->copy($dest);
        $src->copy($sub_dest) if $sub_dest;
    }
    else {
        my $html = $self->_render_string('entry.html', {
            text        => $self->entry_text($src),
            title       => $matter->title,
            subtitle    => $self->entry_subtitle($src),
            matter      => $matter,
        });
        $dest->spew_utf8($html);
        $sub_dest->spew_utf8($html) if $sub_dest;
    }

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
    for ($src_list->@*) {
        my $src      = $_;
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

    # すでにカテゴリ一覧のページが存在していたら、生成しないでおく
    $src_category = Path::Tiny::path($src_category);
    for my $ext ('html', 'txt', 'md', 'markdown') {
        return if $src_category->child("index.$ext")->exists;
    }

    my $content_dir = $self->content_dir;
    my $category = $src_category =~ s!$content_dir!!r;

    my @src_list = map {
        my $file   = Path::Tiny::path($_);
        my $matter = $self->front_matter($file);
        my $name   = $file->basename =~ s!\.[^.]+$!!r;
        my $title  = $matter->exists ? $matter->title : $file->basename . '/';
        my $href   = $matter->exists ? "$category/$name" : "$category/@{[$file->basename]}/";
        {
            file   => $file,
            matter => $matter,
            name   => $name,
            title  => $title,
            href   => $href,
        }
    } $src_list->@*;

    my $html = $self->_render_string('category.html', {
        category    => $category,
        description => $category,
        title       => $category,
        files       => [
            sort {
                Scalar::Util::looks_like_number($a->{name}) && Scalar::Util::looks_like_number($b->{name})
                ? $a->{name} <=> $b->{name}
                : $a->{name} cmp $b->{name}
            } @src_list
        ],
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
    my ($self, $src_list) = @_;

    my %tag_map;
    for my $src ($src_list->@*) {
        my $matter = $self->front_matter($src);
        next unless $matter->exists;

        for my $tag ($matter->tags->@*) {
            push $tag_map{$tag}->@*, $src;
        }
    }

    $self->build_tag_index([keys %tag_map]);

    for my $tag (keys %tag_map) {
        my $src_list = $tag_map{$tag};
        $self->build_tag($tag, $src_list);
    }
}

sub build_tag_index {
    my ($self, $tags) = @_;

    my $html = $self->_render_string('tag_index.html', {
        tags => [sort { $a cmp $b } $tags->@*],
    });

    my $tag_dir = $self->public_dir->child('tag');
    my $dest = $tag_dir->child('index.html');
    $tag_dir->mkpath unless $tag_dir->is_dir;
    $dest->spew_utf8($html);
    $self->diag("Created tag_list $dest\n");
}

sub build_tag {
    my ($self, $tag, $src_list) = @_;

    my @src_list = map {
        my $file   = Path::Tiny::path($_);
        my $matter = $self->front_matter($file);
        my $title  = $matter->title;

        # content/foo/bar.txt => /foo/bar
        my $href = do {
            my $content_dir = $self->content_dir;
            my $path = $file =~ s!$content_dir!!r;
            my $href = $path =~ s!\.([^.]+)$!!r;
            $href;
        };
        {
            file   => $file,
            matter => $matter,
            title  => $title,
            href   => $href,
        }
    } $src_list->@*;

    my $html = $self->_render_string('tag.html', {
        tag         => $tag,
        description => $tag,
        title       => $tag,
        files       => [ sort { $a->{title} cmp $b->{title} } @src_list ],
    });

    my $tag_dir = $self->public_dir->child('tag', $tag);
    my $dest = $tag_dir->child('index.html');
    $tag_dir->mkpath unless $tag_dir->is_dir;
    $dest->spew_utf8($html);
    $self->diag("Created tag $dest\n");
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
    return $self->{__front_matter}{$src} //= do {
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
        no warnings qw(once);
        local $Text::Xatena::Node::SuperPre::SUPERPRE_CLASS_NAME = 'code prettyprint';
        state $xatena = Text::Xatena->new;
        my $inline    = Text::Xatena::Inline->new;
        my $html = $xatena->format( $text, inline => $inline );
        if (scalar @{ $inline->footnotes }) {
            $html .= "\n<div class=\"footnotes\">\n";
            $html .= join "\n", map {
                sprintf(
                    '  <div class="footnote" id="#fn%d">*%d: %s</div>',
                    $_->{number}, $_->{number}, $_->{note},
                )
            } @{ $inline->footnotes };
            $html .= "\n</div>\n";
        }
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
