use Plack::Builder;
 
builder {
    enable "Plack::Middleware::Static",
    path => sub {
        s!/([^\.]+)$!/$1/!;
        s!(.*/$)!$1/index.html! or return qr{^/.+};
    },
    content_type => sub {
        my $file = shift;
        my $content_type = Plack::MIME->mime_type($file) || 'text/plain';

        if ($content_type eq 'application/atom+xml') {
            $content_type .= "; charset=utf-8";
        }

        return $content_type;
    },
    root => './public/';
};
