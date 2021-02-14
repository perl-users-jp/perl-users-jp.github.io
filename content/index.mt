<!doctype html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="<?= $vars->{description} ?>">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Language" content="ja" />
        <meta http-equiv="Content-Style-Type" content="text/css" />
        <meta http-equiv="Content-Script-Type" content="text/javascript" />
        <meta http-equiv="imagetoolbar" content="no" />
        <link rel="alternate" type="application/atom+xml" title="Atom feed" href="https://github.com/perl-users-jp/perl-users-jp.github.io/commits/master.atom" />
        <link rel="shortcut icon" href="/favicon.ico" type="image/vnd.microsoft.icon" />
        <link rel="icon" href="/favicon.ico" type="image/vnd.microsoft.icon" />

        <title>Perl-users.jp - 日本のPerlユーザのためのハブサイト</title>
        <link rel="icon" href="/img/favicon.ico">
        <link rel="canonical" href="<?= $vars->{url} ?>">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.min.css">
        <link rel="stylesheet" href="/css/main.css">
        <script async src="https://www.googletagmanager.com/gtag/js?id=UA-4463402-1"></script>
        <script>
          window.dataLayer = window.dataLayer || [];
          function gtag(){dataLayer.push(arguments);}
          gtag('js', new Date());

          gtag('config', 'UA-4463402-1');
        </script>
    </head>
    <body>
        <?= $include->('./include/header.html') ?>
        <main>
            <div class="jumbotron">
                <h1>日本のPerlユーザーのためのハブサイト</h1>
                <p class="lead">日本の Perl ユーザーに最新の情報を届けたい</p>
            </div>

            <h2>Perlを試してみる</h2>
            webperl

            open play ground

            <h2>注目記事</h2>

            記事aaaaaaaaaaaaa

            記事bbbb

            何かリストを用意しておいて、そこからランダムで埋め込み
            [もっと読む](Blog)

            <h2>注目動画</h2>
            何かリストを用意しておいて、そこからランダムで埋め込み
        </main>
        <?= $include->('./include/footer.html') ?>
    </body>
</html>
