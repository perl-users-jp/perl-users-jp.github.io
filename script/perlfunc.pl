#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use 5.010000;
use autodie;

use Pod::Functions;

binmode *STDOUT, ":utf8";

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


# use Data::Dumper; warn Dumper(\%Kinds);
for (@Type_Order) {
    print qq{<div class="row-fluid content-block"><div class="span12"><h4>} . ($en2jp{$_} || $_) . "</h4>\n<p>\n";
    for (@{$Kinds{$_}}) {
       next if /^__/; # skip if __SUB__, __END__, __FILE__
       my $link = "$_";
       $link =~ s!/.*!!; # s/// => s
       print qq{<a href="http://perldoc.jp/func/$link">$_</a>\n};
    }
    print "</p></div></div>\n";
}

