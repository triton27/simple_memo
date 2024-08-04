require 'sinatra'
require 'sinatra/reloader'
require_relative 'models/memo'

# トップ画面表示
get '/memos' do
  @title = 'Top'
  @memos = Memo.read_memos

  erb :top
end

get '/' do
  redirect '/memos'
end

# 登録画面表示
get '/new' do
  @title = 'New memo'

  erb :new
end

# 登録処理
post '/memos' do
  memos = Memo.read_memos

  id = memos.empty? ? 1 : memos.max_by(&:id).id + 1
  title = params['title'].empty? ? "新しいメモ (#{id})" : params['title']

  new_memo = Memo.new(id, title, params['description'])
  Memo.insert_memo(new_memo)

  redirect '/memos'
end

# 詳細画面表示
get '/memos/:id' do
  @title = 'Show memo'
  @memo = Memo.read_memo(params['id'].to_i)

  erb :show
end

# 編集画面表示
get '/memos/:id/edit' do
  @title = 'Edit memo'
  @memo = Memo.read_memo(params['id'].to_i)

  erb :edit
end

# 編集処理
patch '/memos/:id' do
  memos = Memo.read_memos
  id = params['id'].to_i

  memo = memos.find { |m| m.id == id }
  memo.title = params['title']
  memo.description = params['description']

  Memo.update_memo(memo)

  redirect "/memos/#{id}"
end

# 削除処理
delete '/memos/:id' do
  memos = Memo.read_memos
  memo = memos.find { |m| m.id == params['id'].to_i }
  Memo.delete_memo(memo)

  redirect '/memos'
end

not_found do
  '404 Not Found'
end

# XSS対策
helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
