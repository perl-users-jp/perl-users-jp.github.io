package PerlUsersJP::Builder;
use strict;
use warnings;
use utf8;
use feature qw(state);

use PerlUsersJP::Entry;

use Path::Tiny ();
use Date::Format ();
use Text::Xatena;
use Text::Xatena::Inline;
use Text::Markdown;
use Text::MicroTemplate;

use Class::Tiny qw(
    src_dir
    docs_dir
    layouts_dir
);

sub BUILDARGS {
    my ($class, %args) = @_;

    die "required 'src_dir'"     unless exists $args{src_dir};
    die "required 'docs_dir'"    unless exists $args{docs_dir};
    die "required 'layouts_dir'" unless exists $args{layouts_dir};

    return {
        src_dir     => ref $args{src_dir}     ? $args{src_dir}     : Path::Tiny::path($args{src_dir}),
        docs_dir    => ref $args{docs_dir}    ? $args{docs_dir}    : Path::Tiny::path($args{docs_dir}),
        layouts_dir => ref $args{layouts_dir} ? $args{layouts_dir} : Path::Tiny::path($args{layouts_dir}),
    }
}


sub run {
    my ($self) = @_;

    my (@entries, @static);
    my $iter = $self->src_dir->iterator({ recurse => 1 });
    while (my $src = $iter->()) {
        next unless $src->is_file;
        push @entries => $src if $self->is_entry($src);
        push @static  => $src if $self->is_static($src);
    }

    $self->diag("Build Start\n");
    $self->build_static_src_list(\@static);
    $self->build_entry_src_list(\@entries);
    $self->diag("Build Finished\n");
}

sub build_static_src_list {
    my ($self, $static_src_list) = @_;
    for my $src ($static_src_list->@*) {
        $self->build_dest_dir($src);
        $self->build_static($src);
    }
}

sub build_entry_src_list {
    my ($self, $entry_src_list) = @_;
    my @entries;
    for my $src ($entry_src_list->@*) {
        my $entry = PerlUsersJP::Entry->new($src);
        push @entries => $entry;

        $self->build_dest_dir($src);
        $self->build_entry($entry);
    }

    # TODO
    #$self->build_tags(\@entries);
    #$self->build_category(\@entries);
    #$self->build_sitemap(\@entries);
    #$self->build_atom(\@entries);
}

sub build_dest_dir {
    my ($self, $src) = @_;
    my $dest = $self->dest_dir($src);
    if (!$dest->is_dir) {
        $dest->mkpath;

        $self->diag("Created dest_dir $dest\n");
    }
}

sub build_static {
    my ($self, $src) = @_;
    my $dest_dir = $self->dest_dir($src);
    my $dest = $src->copy($dest_dir);

    $self->diag("Created static $dest\n");
}

sub build_entry {
    my ($self, $entry) = @_;
    my $template = $self->layouts_dir->child('entry.html');

    my $format = $entry->format // $self->detect_format($entry->file);
    my $text   = $self->format_text($entry->body, $format);

    my $html = _render_string($template, {
        text  => $text,
        entry => $entry,
    });

    my $name = $entry->file->basename =~ s!\.[^.]+$!.html!r;
    my $dest = $self->dest_dir($entry->file)->child($name);
    $dest->spew_utf8($html);

    $self->diag("Created entry $dest\n");
}

sub build_tags {
    my ($self, $entries) = @_;
    my %entries;
    for my $entry ($entries->@*) {
        for my $tag ($entry->tags->@*) {
            push $entries{$tag}->@* => $entry
        }
    }

    for my $tag (keys %entries) {
        my $entries = $entries{$tag};
        my $template = $self->dest_layouts_dir->child('tag.html');
        my $html     = _render_string($template, {
            entries => $entries
        });

        my $dest = $self->dest_root_dir->child('tags', $tag, 'index.html');
        $dest->spew_utf8($html);
    }
}

sub build_category {
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

sub dest_dir {
    my ($self, $src) = @_;
    my $src_dir  = $self->src_dir;
    my $dir      = $src->parent =~ s!$src_dir!!r;
    my $dest_dir = $dir ? $self->docs_dir->child($dir) : $self->docs_dir;
    return $dest_dir
}

sub is_entry {
    my ($self, $src) = @_;
    return !!$self->detect_format($src)
}

sub is_static {
    my ($self, $src) = @_;
    return !$self->is_entry($src)
}

sub detect_format {
    my ($self, $src) = @_;

    my ($ext) = $src =~ m!\.([^.]+)$!;
    return $ext eq 'md'       ? 'markdown'
         : $ext eq 'markdown' ? 'markdown'
         : $ext eq 'txt'      ? 'hatena'
         : undef
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
    else {
        die "unsupported format: $format";
    }
}

sub _render_string {
    my ($template, $vars) = @_;
    $template = $template->slurp_utf8 if ref $template;

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
