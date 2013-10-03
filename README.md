perl-users.jp-htdocs
====================

perl-users.jp のソースです。

加筆/修正したい場合は、fork & pull-req してください。

## ビルドする方法

make コマンドを実行してください。ビルドした結果が static/ に出力されるので、それもコミットしてください。

(Yappo さんのサーバーで対応してもらうようにしたら、make はサーバー側でうてばよくなる)

## 必要なもの

 * Perl 5.18.1 以後
 * 最新の Carton

## Makefile のつかいかた

### make

make dynamic でたちあがるサーバーから wallflower でコンテンツを収集し、static/ 以下に配置します。

### make test

テストを実行します。

### make dynamic

動的にコンテンツを表示するサーバーをたちあげます。

### make static

static/ のデータを確認するために Plack::App::Directory をつかってサーバーをたちあげます。


