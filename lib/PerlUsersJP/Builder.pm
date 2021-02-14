package PerlUsersJP::Builder;
use strict;
use warnings;
use utf8;
use feature qw(state);

use PerlUsersJP::FrontMatter;

use Encode::Locale;
use Encode qw(encode);
use Path::Tiny qw(path);
use Date::Format qw(time2str);
use Scalar::Util qw(looks_like_number);
use URI::Escape qw(uri_escape_utf8);

use Text::MicroTemplate;
use XML::Atom::Feed;
use XML::Atom::Entry;
use XML::Atom::Person;
use XML::Atom::Link;

use Text::Xatena;
use Text::Xatena::Inline;
use Text::Markdown;
use Pod::Simple::XHTML;

use Class::Tiny qw(
    content_dir
    public_dir
    layouts_dir
);

our $HOST = 'perl-users.jp';

my $ATOM_FEED_COUNT = 10;
my $DATE_FORMAT     = '%Y-%m-%dT%H:%M:%S%z';

sub BUILDARGS {
    my ($class, %args) = @_;

    die "required 'content_dir'" unless exists $args{content_dir};
    die "required 'public_dir'"  unless exists $args{public_dir};
    die "required 'layouts_dir'" unless exists $args{layouts_dir};

    return {
        content_dir => ref $args{content_dir} ? $args{content_dir} : path($args{content_dir}),
        public_dir  => ref $args{public_dir}  ? $args{public_dir}  : path($args{public_dir}),
        layouts_dir => ref $args{layouts_dir} ? $args{layouts_dir} : path($args{layouts_dir}),
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

    my $categories = $self->build_categories($src_list);
    my $tags       = $self->build_tags($src_list);
    $self->build_atom_feed($src_list);
    $self->build_sitemap($src_list, $categories, $tags);
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
    elsif ($matter->format eq 'microtemplate') {
        my $html = $self->_render_string($src);
        $dest->spew_utf8($html);
        $sub_dest->spew_utf8($html) if $sub_dest;
    }
    else {
        my $html = $self->_render_string('entry.html', {
            text         => $self->entry_text($src),
            title        => $matter->title,
            subtitle     => $self->entry_subtitle($src),
            fulltitle    => $self->entry_fulltitle($src),
            matter       => $matter,
            url          => $self->entry_url($src),
            og_image_url => $matter->og_image // $self->og_image_url($src),
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

sub entry_fulltitle {
    my ($self, $src) = @_;
    my $title    = $self->front_matter($src)->title;
    my $subtitle = $self->entry_subtitle($src);
    return $subtitle ? "$title - $subtitle" : $title;
}

sub build_categories {
    my ($self, $src_list) = @_;

    my %src_list_map;
    for ($src_list->@*) {
        my $src      = $_;
        my $src_category = $src->parent;
        while ($src_category ne $self->content_dir) {
            $src_list_map{$src_category}{$src} = 1;
            $src          = $src_category;
            $src_category = $src->parent;
        }
    }

    my @categories;

    my $content_dir = $self->content_dir;
    for my $src_category (keys %src_list_map) {

        # すでにカテゴリ一覧のページが存在していたら、生成しないでおく
        next if $self->_is_category_page_exists($src_category);

        my @src_list = keys $src_list_map{$src_category}->%*;
        my $category = $self->chomp_content_dir($src_category);
        $self->build_category($category, \@src_list);
        push @categories => $category;
    }

    return \@categories;
}


sub _is_category_page_exists {
    my ($self, $src_category) = @_;
    for my $ext ('html', 'txt', 'md', 'markdown') {
        return 1 if path($src_category, "index.$ext")->exists;
    }
    return 0;
}



sub build_category {
    my ($self, $category, $src_list) = @_;

    my @src_list = map {
        my $file   = path($_);
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
        url         => $self->category_url($category),
        files       => [
            sort {
                looks_like_number($a->{name}) && looks_like_number($b->{name})
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

    return [ keys %tag_map ];
}

sub build_tag_index {
    my ($self, $tags) = @_;

    my $html = $self->_render_string('tag_index.html', {
        url          => $self->tag_index_url,
        tag_url_path => sub { $self->tag_url_path(@_) },
        tags => [sort { $a cmp $b } $tags->@*],
        description  => '',
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
        my $file   = path($_);
        my $matter = $self->front_matter($file);
        my $title  = $matter->title;
        my $href   = $self->entry_url_path($file);

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
        url         => $self->tag_url($tag),
        files       => [ sort { $a->{title} cmp $b->{title} } @src_list ],
    });

    my $tag_dir = $self->public_dir->child('tag', encode(locale => _normalize_name($tag)));
    my $dest = $tag_dir->child('index.html');
    $tag_dir->mkpath unless $tag_dir->is_dir;
    $dest->spew_utf8($html);
    $self->diag("Created tag $dest\n");
}

sub build_sitemap {
    my ($self, $src_list, $categories, $tags) = @_;

    my @url_list;

    # CASE: entry
    for my $src ($src_list->@*) {
        my $loc      = $self->entry_url($src);
        my $lastmod  = time2str($DATE_FORMAT, $src->stat->mtime);
        my $count    = scalar grep { $_ ne 'index.html' } split qr!/!, $src;
        my $priority = int((0.8 ** ($count - 1)) * 100) / 100;
        push @url_list => {
            loc      => $loc,
            lastmod  => $lastmod,
            priority => $priority,
        }
    }

    # CASE: category
    for my $category ($categories->@*) {
        my $loc      = $self->category_url($category);
        my $count    = scalar split qr!/!, $category;
        my $priority = int((0.8 ** ($count - 1)) * 100) / 100;
        push @url_list => {
            loc      => $loc,
            priority => $priority,
        }
    }

    # CASE: tag
    push @url_list => {
        loc      => $self->tag_index_url(),
        priority => 0.8 ** 1
    };
    for my $tag ($tags->@*) {
        my $loc      = $self->tag_url($tag);
        push @url_list => {
            loc      => $loc,
            priority => 0.8 ** 2,
        }
    }

    @url_list = sort { $b->{priority} <=> $a->{priority} } @url_list;

    my $xml = $self->_render_string('sitemap.xml', {
        url_list => \@url_list,
    });

    my $dest = $self->public_dir->child('sitemap.xml');
    $dest->spew_utf8($xml);
    $self->diag("Created sitemap $dest\n");
}

sub build_atom_feed {
    my ($self, $src_list) = @_;

    my $feed = XML::Atom::Feed->new;
    $feed->title('新着記事 - Perl Users JP');
    $feed->id("tag:$HOST,2020:/feed");
    $feed->lang('ja-JP');

    { # link alternate
        my $link = XML::Atom::Link->new;
        $link->type('text/html');
        $link->rel('alternate');
        $link->href("https://$HOST");
        $feed->add_link($link);
    }

    { # link self
        my $link = XML::Atom::Link->new;
        $link->type('application/atom+xml');
        $link->rel('self');
        $link->href("https://$HOST/feed.atom");
        $feed->add_link($link);
    }

    my @sorted = sort { $b->stat->mtime <=> $a->stat->mtime } $src_list->@*;
    my @new_src_list = splice @sorted, 0, $ATOM_FEED_COUNT;
    for my $src (@new_src_list) {
        my $entry = XML::Atom::Entry->new;

        my $matter = $self->front_matter($src);
        my $path   = $self->entry_url_path($src);

        $entry->title($matter->title);
        $entry->id("tag:$HOST,2020:$path");
        $entry->updated(time2str($DATE_FORMAT, $src->stat->mtime));
        #$entry->published(time2str($DATE_FORMAT, $src->stat->mtime)); # FIXME mtime
        $entry->content(
            $self->entry_text($src)
        );

        my $author = XML::Atom::Person->new;
        $author->name($matter->author);
        $entry->author($author);

        my $link = XML::Atom::Link->new;
        $link->type('text/html');
        $link->rel('alternate');
        $link->href($self->entry_url($src));

        $feed->add_entry($entry);
    }

    my $first_src = $new_src_list[0];
    $feed->updated(time2str($DATE_FORMAT, $first_src->stat->mtime));

    my $xml = $feed->as_xml;

    my $atom_dir = $self->public_dir->child();
    my $dest = $atom_dir->child('feed.atom');
    $atom_dir->mkpath unless $atom_dir->is_dir;
    $dest->spew($xml);
    $self->diag("Created atom $dest\n");
}




sub diag {
    my ($self, $msg) = @_;
    print $msg;
}

sub to_public {
    my ($self, $src) = @_;
    my $dir = $self->chomp_content_dir($src);
    return $dir ? $self->public_dir->child($dir) : $self->public_dir;
}

sub chomp_content_dir {
    my ($self, $path) = @_;
    my $content_dir = $self->content_dir;
    return $path =~ s!^$content_dir!!r;
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
        my $html = Text::Markdown::markdown($text);
        $html =~ s/<code>/<code class="prettyprint">/g;
        return $html
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
                    '  <div class="footnote" id="fn%d">*%d: %s</div>',
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
        $out =~ s/<code>/<code class="prettyprint">/g;
        return $out
    }
    elsif ($format eq 'html') {
        return $text;
    }
    elsif ($format eq 'microtemplate') {
        return $text;
    }
    else {
        die "unsupported format: $format";
    }
}

sub url {
    my ($self, $path) = @_;
    return "https://$HOST" . $path;
}

# e.g. content/foo/bar.txt => /foo/bar
sub entry_url_path {
    my ($self, $src) = @_;

    my $content_dir = $self->content_dir;
    my $path = "$src";
    $path =~ s!$content_dir!!;
    $path =~ s!\.([^.]+)$!!;
    $path =~ s!index$!!;
    return $path;
}

sub category_url_path {
    my ($self, $category) = @_;
    return "$category/";
}

sub tag_url_path {
    my ($self, $tag) = @_;
    return sprintf("/tag/%s", _normalize_name($tag));
}

sub entry_url     { my $self = shift; $self->url($self->entry_url_path(@_)) }
sub category_url  { my $self = shift; $self->url($self->category_url_path(@_)) }
sub tag_url       { my $self = shift; $self->url($self->tag_url_path(@_)) }
sub tag_index_url { $_[0]->url("/tag/") }

sub og_image_url {
    my ($self, $src) = @_;

    my $title_font_family = 'NotoSansJP-Black.otf';
    my $title_font_size   = '50';
    my $title_font_weight = 'bold';
    my $title_font_color  = '000000';
    my $title_width       = '900';

    my $author_font_family = 'NotoSansJP-Black.otf';
    my $author_font_size   = '30';
    my $author_font_weight = 'bold';
    my $author_font_color  = '000000';
    my $author_x           = '130';
    my $author_y           = '120';

    my $matter = $self->front_matter($src);

    # XXX commaがcloudinaryだと文字区切りの意味を持つので、代替文字に置き換え
    # https://support.cloudinary.com/hc/en-us/community/posts/200788162-Using-special-characters-in-Text-overlaying-
    my $title  = $matter->title =~ s!,!%E2%80%9A!gr;
    my $author = $matter->author =~ s!,!%E2%80%9A!gr;

    my $title_option = join ',', (
        "l_text:${title_font_family}_${title_font_size}_${title_font_weight}:@{[ uri_escape_utf8 $title ]}",
        "co_rgb:${title_font_color}",
        "w_${title_width}",
        "c_fit",
    );

    my $author_option = join ',', (
        "l_text:${author_font_family}_${author_font_size}_${author_font_weight}:@{[ uri_escape_utf8 $author ]}",
        "co_rgb:${author_font_color}",
        "g_south_east",
        "x_${author_x}",
        "y_${author_y}",
    );

    return sprintf("https://res.cloudinary.com/kfly8/image/upload/%s/%s/v1601626948/og-perl-users-jp.png", $title_option, $author ? $author_option : '')
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
        my \$include = shift;
        $code->();
    }
    ...

    return $renderer->($vars, sub { $self->_render_string(@_) });
}

sub _normalize_name {
    my ($name) = @_;
    return $name =~ s!::!-!gr;
}

1;
