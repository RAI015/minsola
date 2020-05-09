# MinSola
今の空の写真を投稿し、天気の様子をゆるく報告・共有できるアプリです。<br>
開発環境と本番環境にDocker、インフラにAWSの各種サービスを活用しています。<br>
また、CircleCIを用いてCI/CDパイプラインを実現しています。

![MinSola画面](https://user-images.githubusercontent.com/62027190/81408814-e1e1dc00-9178-11ea-9304-83876c71af6e.png)

## 制作背景
昔からぼーっと空を眺めることが好きだったので、空の画像を共有できてゆるめの天気予報コミュニティになれるアプリがあったらいいなと思い、制作しました。

## URL
https://www.minsola.work/ <br>
非ログイン状態の場合は閲覧、検索のみ可能です。ログインすると投稿やコメントが可能になります。<br>
ログイン画面の「かんたんログイン」をクリックすると、メールアドレスとパスワードを入力せずにログインできます。<br>
メールアドレス"`admin@example.com`"、パスワード"`12345678`"で【管理者】としてログインできます。<br>
管理者は、他の一般ユーザーのアカウントや投稿、コメントを削除できる権限を持ちます。<br>

## 使用技術
- Ruby 2.6.5, Rails 5.2.4.2
- MySQL 5.7.30
- Nginx, Puma
- AWS（VPC, ECS, ECR, RDS, Route 53, ELB, ACM, S3, CloudFront）
- Docker/docker-compose
- CircleCI (CI/CDパイプラインを構築)
- RSpec
- Sass, Bootstrap, jQuery

## AWS構成図
![AWS構成図](https://user-images.githubusercontent.com/62027190/81407724-d7bede00-9176-11ea-8daf-bc4426d9668b.png)

## 機能一覧
- ユーザー機能
  - deviseを使用
  - 新規登録、ログイン、ログアウト機能
  - マイページ、登録情報編集機能
- 記事関係
  - 記事一覧表示、記事詳細表示、記事投稿、記事編集、記事削除機能
  - 画像のアップロードはcarrierwaveを使用
- コメント関係
  - コメント表示、コメント投稿、コメント削除機能
- ページネーション機能
  - (kaminari + Infinite Scroll)を使用
- いいね機能
  - 登録したいいねの一覧表示、人気順表示機能
  - Ajaxを使用
- フォロー機能
  - フォロー、フォロワー一覧表示機能
  - Ajaxを使用
- 検索機能
  - 複数の検索条件を指定可能
- 管理ユーザー機能
  - ユーザー一覧の表示、一般ユーザーのアカウントや投稿、コメントを削除可能
- Rspecによる自動テスト機能
  - 単体テスト機能
  - 統合テスト機能
- その他
  - SelectBoxの中身を動的に変更する機能
    - 都道府県SelectBoxに対する市区町村SelectBoxをAjaxで動的に制御

## ER図
![ER図](https://user-images.githubusercontent.com/62027190/80856252-3372fe00-8c83-11ea-8165-75f6cd0f37c7.png)

## 参考アプリケーション
[ウェザーリポートCh. - ウェザーニュース](http://weathernews.jp/s/report/read/index.html)