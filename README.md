
# WIP

perl-users.jp をGitHub Pagesに移管作業をしています。
https://github.com/perl-users-jp/test-perl-users-jp/projects/1

# ビルドする方法

1. content/ 以下を編集し、記事を書く
2. commit & push
    - pushするとGitHub Actionsでビルドします

開発環境で記事を確認したい場合は、Make

# 必要なもの

- perl 5.30 以降 (できるだけ最新に保つ)
- 最新のCarton

# Makefileのつかいかた

- `make` or `make build`
    - content/ 以下にある記事を元にビルドして、public/ 以下に配置します。
- `make clean`
    - public/ 以下を削除します
- `make test`
    - テストを実行します
- `make server`
    - public/ のデータを確認するために Plack::App::Directory をつかってサーバーをたちあげます。

