# simple_memo

## How to use

### 1. 任意の作業ディレクトリにて git clone する

### 2. Gem をインストール

```
bundle install
```

### 3. PostgreSQL の準備

#### インストール

```
brew install postgresql
```

#### 起動

```
brew services start postgresql
```

#### DB の作成

```
createdb -O devuser01 simple_memo
```

#### テーブルの作成

```
CREATE TABLE memos
(id INTEGER PRIMARY KEY,
title TEXT NOT NULL,
description TEXT);
```

### 4. アプリを起動

```
bundle exec ruby app.rb
```

### 5. ブラウザでアクセス

```
http://localhost:4567/memos
```

## Notes

### PostgreSQL の停止

```
brew services stop postgresql
```