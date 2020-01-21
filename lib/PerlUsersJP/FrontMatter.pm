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

    my $content = ref $file && $file->can('slurp_utf8') ? $file->slurp_utf8 : $file;
    my $data    = _parse_entry($content);
    my $tags    = $data->{tags} ? [split ',', $data->{tags}] : [];

    return {
        body        => $data->{body},
        title       => $data->{title} // '',
        description => $data->{description} // '',
        author      => $data->{author} // '',
        tags        => $tags,
        layout      => $data->{layout},
        format      => $data->{format},
    }
}

sub _parse_entry {
    my ($content) = @_;

    # TODO: Front Matterをこの辺と合わせたい?
    #  - https://jekyllrb.com/docs/front-matter/
    #  - https://gohugo.io/content-management/front-matter/
    my ($raw_meta, $body) = split("\n\n", $content, 2);
    if (!$raw_meta || !$body) {
        die "Failed to parse entry: $content";
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
