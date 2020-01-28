package PerlUsersJP::FrontMatter;
use strict;
use warnings;
use utf8;

use Class::Tiny qw(
    body       

    title      
    description
    author     
    tags       

    layout     
    format     
);

sub BUILDARGS {
    my ($class, $file) = @_;

    die "required 'file'" unless $file;

    unless (ref $file && $file->is_file) {
        return {};
    }

    my $format = _detect_entry_format($file);
    if (!$format) {
        # file is not entry
        return {};
    }
    elsif ($format eq 'html') {
        my $data = _parse_html_entry($file);

        return {
            format => $format,
            title  => $data->{title} // '',
            tags   => [], # TODO HTMLでもタグ対応したいね
        }
    }
    else {
        my $data    = _parse_text_entry($file);
        my $tags    = $data->{tags} ? [ grep { $_ } map { s!\s*!!; s!\s*$!!; $_ } split /[,\s]/, $data->{tags} ] : [];

        return {
            body        => $data->{body},
            title       => $data->{title} // '',
            description => $data->{description} // '',
            author      => $data->{author} // '',
            tags        => $tags,
            layout      => $data->{layout},
            format      => $data->{format} // $format,
        }
    }
}

sub exists {
    my $self = shift;
    exists $self->{format}
}

sub _detect_entry_format {
    my ($file) = @_;

    my ($ext) = $file =~ m!\.([^.]+)$!;
    return !$ext              ? undef
         : $ext eq 'md'       ? 'markdown'
         : $ext eq 'markdown' ? 'markdown'
         : $ext eq 'txt'      ? 'hatena'
         : $ext eq 'html'     ? 'html'
         : undef
}

sub _parse_html_entry {
    my ($file) = @_;

    # TODO
    my $title = $file->basename;

    return {
        title => $title,
    }
}

sub _parse_text_entry {
    my ($file) = @_;

    # TODO: Front Matterをこの辺と合わせたい?
    #  - https://jekyllrb.com/docs/front-matter/
    #  - https://gohugo.io/content-management/front-matter/
    my ($raw_meta, $body) = split("\n\n", $file->slurp_utf8, 2);
    if (!$raw_meta || !$body) {
        die "Failed to parse entry: $file";
    }
    my $meta = _parse_meta($raw_meta);

    return {
        body => $body,
        $meta->%*
    }
}

sub _parse_meta {
    my ($raw_meta) = @_;

    my ($title, %meta);
    for (split /\n/, $raw_meta) {
        if (my ($key, $value) = m{^meta-(\w+):\s*(.+)\s*$}) {
            $meta{$key} = $value;
        }
        else {
            $title = $_;
        }
    }

    return {
        title => $title,
        %meta
    };
}

1;
