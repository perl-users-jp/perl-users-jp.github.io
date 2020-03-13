
# 手伝いをしてくれる人を募集しています:muscle:

perl-users.jpをGitHub Pagesへ移管しています。その手伝いをしてくれる人を募集しています！
具体的なissueは、次のプロジェクトに記載しています。
https://github.com/perl-users-jp/perl-users-jp.github.io/projects/1

誰でも気軽に参加してもらえればと思っています!
やってみたいissueがあれば、pull request待っています。
不明点などあれば、お気軽に[@kfly8](https://twitter.com/kfly8)までご連絡ください。

-----


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

