package Pujp::PerlFunc;
use strict;
use warnings;
use utf8;
use 5.018_001;

use Pod::Functions;

my %en2jp = (
    String => '文字列',
    Regexp => '正規表現',
    Math => '数学',
    ARRAY => '配列',
    LIST => 'リスト',
    HASH => 'ハッシュ',
    'I/O' => '入出力',
    'Binary' => 'バイナリ',
    'File' => 'ファイル',
    Flow => 'コントロールフロー',
    Namespace => 'ネームスペース',
    Misc => 'その他',
    Process => 'プロセス',
    Modules => 'モジュール',
    Objects => 'オブジェクト',
    Socket => 'ソケット',
    SysV  => 'SysV',
    User => 'ユーザー',
    Network => 'ネットワーク',
    Time => '時刻',
);

sub list {
    my @ret;

    for (@Type_Order) {
        my @rows;
        for (@{$Kinds{$_}}) {
            next if /^__/; # skip if __SUB__, __END__, __FILE__
            my $link = "$_";
            $link =~ s!/.*!!; # s/// => s

            push @rows, {
                link => "http://perldoc.jp/func/$link",
                name => $_,
            };
        }

        push @ret, {
            title => $en2jp{$_} || $_,
            rows  => \@rows,
        };
    }

    return @ret;
}

1;

