require 'sinatra'
require 'sinatra/reloader'
require 'json'
require_relative 'models/memo'

# トップ画面表示
get '/' do
  @title = 'Top'
  @memos = Memo.read_memos

  erb :top
end

# 登録画面表示
get '/new' do
  @title = 'New memo'

  erb :new
end

# 登録処理
post '/create' do
  memos = Memo.read_memos

  memo_id = memos.empty? ? 1 : memos.max_by { |m| m['memo_id'] }['memo_id'] + 1
  memo_title = params['memo_title'].empty? ? "新しいメモ (#{memo_id})" : params['memo_title']

  new_memo = { 'memo_id' => memo_id,
               'memo_title' => memo_title,
               'memo_description' => params['memo_description'] }

  memos << new_memo

  Memo.write_memos(memos)

  redirect '/'
end

# 詳細画面表示
get '/memos/:memo_id' do
  @title = 'Show memo'
  @memo = Memo.new(params['memo_id'].to_i)

  erb :show
end

# 編集画面表示
get '/memos/:memo_id/edit' do
  @title = 'Edit memo'
  @memo = Memo.new(params['memo_id'].to_i)

  erb :edit
end

# 編集処理
patch '/memos/:memo_id' do
  memos = Memo.read_memos
  memo_id = params['memo_id'].to_i

  memos.each do |m|
    next unless m['memo_id'] == memo_id

    m['memo_title'] = params['memo_title']
    m['memo_description'] = params['memo_description']
    break
  end

  Memo.write_memos(memos)

  redirect "/memos/#{memo_id}"
end

# 削除処理
delete '/memos/:memo_id' do
  memos = Memo.read_memos
  memo_id = params['memo_id'].to_i

  memos.delete_if { |m| m['memo_id'] == memo_id }

  Memo.write_memos(memos)

  redirect '/'
end

not_found do
  '404 Not Found'
end
