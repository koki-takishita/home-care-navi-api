## やったこと

- このプルリクで何をしたのか？

## やらないこと

- このプルリクでやらないことは何か？（**やらない場合は、いつやるのかを明記する**）

### API 側

- fetch and checkout

```ruby
git fetch && git checkout origin/<ここを変える>/<ここを変える>
```

### Front 側

- fetch and checkout

```ruby
git fetch && git checkout origin/<ここを変える>/<ここを変える>
```

### 動作確認 Loom 手順

- 〇〇をする

```ruby

```

### 確認書類

**URL は該当のものに変えること**  
[API 一覧](https://docs.google.com/spreadsheets/d/1sJ_ZjXjCdBJkpl0gbS_HX3wDeZhihUoqddtIrHCPFnY/edit#gid=0)  
[ユーザーストーリー](https://docs.google.com/spreadsheets/d/1lORIuXfr7PV5dslAHE4NnRGgNqk0hJ5krfN-tV2YKq8/edit#gid=0)  
[テスト仕様書](https://docs.google.com/spreadsheets/d/12xMuHo1K8Fd7FIB7rqeioxdWmrWw7aYK4QZ_Clsfk5Q/edit#gid=1789577746)  
[テーブル定義書](https://docs.google.com/spreadsheets/d/15AbCnOzcFlnN8CO-sXxKM6bMS7VtExbew-FpYHav91Q/edit#gid=1771130073)

## 参考になったサイト

- [サイトのタイトル（必須） なければ「なし」と記入](url)

## 確認項目

- [ ] ここまでで各項目に漏れなく記入しているか・不要な箇所はないか

```javascript
NG
API・Front両方ブランチを指定していない（developの場合は省略可）
フロントのプルリクとセットで確認する場合は、フロントのプルリクのURLを添付する
```

- [ ] プルリクのタイトルがコミット名そのままになっていないか
- [ ] レビュワーを正しく設定しているか
- [ ] 変数名・メソッド名は適切か　[Ruby の命名規約](https://qiita.com/takahashim/items/ccfd489c9b26f15b7193)
- [ ] インデントが揃えてあるか 余分なスペースはないか
- Rubocop 自動修正コマンド

```ruby
docker-compose exec web bundle exec rubocop --auto-correct 作成・変更したファイルの相対パス
```

- [ ] 作成・変更したファイルに対して Rubocop のチェックがすべてパスしているか
