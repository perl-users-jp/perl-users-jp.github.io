
# 記事を書く方法

## 1. 記事を書く

content/ 配下にmarkdownで記事を書く。 記事は、次のように冒頭にメタ要素を書き、それ以下に内容を書く。

```:sample.md
何かタイトル
meta-author: YOURNAME
meta-tags: foo, bar
meta-date: 2020-12-01

# 何かヘッダー
何か内容。
```

## 2. 記事の確認する

- `make server`で、記事をビルドし、`perl-users.jp`のローカルサーバを立ち上げられる
- `make build`で、記事をビルドできる

## 3. deploy

- content branchに反映する
  - writer権限を持っている場合は、content branchに直接反映する
  - writer権限がなければ、pull requestを作る
- content branchに反映されれば、GitHub Actionsで自動で反映される

# 必要なもの

- perl 5.30 以降 (できるだけ最新に保つ)
- App::cpm

# Makefileのつかいかた

- `make` or `make build`
    - content/ 以下にある記事を元にビルドして、public/ 以下に配置します。
- `make clean`
    - public/ 以下を削除します
- `make test`
    - テストを実行します
- `make server`
    - public/ のデータを確認するために Plack::App::Directory をつかってサーバーをたちあげます。
