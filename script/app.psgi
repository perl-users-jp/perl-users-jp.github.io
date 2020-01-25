use Plack::Builder;
 
builder {
    enable "Plack::Middleware::Static",
    path => sub {
        s!/([^\.]+)$!/$1/!;
        s!(.*/$)!$1/index.html! or return qr{^/.+};
    },
    root => './public/';
};
