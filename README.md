WIP

- 個人用のメモ帳
- 前にPHPで作成したものをRailsとNext.jsを使用して書き直す
- ローカルへの設置を想定

## TODO

- API作成
- フロント
- 画像アップロード
- タグ機能
- 検索
- 月別リスト
- 認証
- 暗号化

## 実行

### Rails

```
cd rails
docker-compose up
docker exec -it [コンテナID] bash

rake db:create
rails db:migrate
rails init_app[【32文字のランダムなキー】] RAILS_ENV=【環境変数】
# 例 rails init_app[12345678901234567890123456789012] RAILS_ENV=development
```

### Next.js

```
cd nextjs

# 開発時
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# 使用時
docker-compose run --rm node sh -c "cd feete && npm run build"
docker-compose -f docker-compose.yml up

docker-compose up
```
