require 'sinatra'
require 'sinatra/reloader'
require 'json'

JSON_PATH = 'public/memos.json'

before do
  @memos = JSON.load_file(JSON_PATH)
end

# トップ画面表示
get '/' do
  @title = 'Top'
  erb :top
end

# 登録画面表示
get '/new' do
  @title = 'New memo'
  erb :new
end

# 登録処理
post '/create' do
  if @memos.empty?
    memo_id = 1
  else
    memo_id = @memos.max_by { |m| m['memo_id'] }['memo_id'] + 1
  end

  if params['memo_title'].empty?
    memo_title = "新しいメモ (#{memo_id})"
  else
    memo_title = params['memo_title']
  end

  new_memo = { 'memo_id' => memo_id,
               'memo_title' => memo_title,
               'memo_description' => params['memo_description'] }

  @memos << new_memo

  File.open(JSON_PATH, 'w') { |file| file.write(JSON.pretty_generate(@memos)) }

  redirect '/'
end

# 詳細画面表示
get '/memos/:memo_id' do
  @title = 'Show memo'

  memo_id = params['memo_id'].to_i
  memo = @memos.find { |m| m['memo_id'] == memo_id }

  @memo_id = memo_id
  @memo_title = memo['memo_title']
  @memo_description = memo['memo_description']

  erb :show
end

# 編集画面表示
get '/memos/:memo_id/edit' do
  @title = 'Edit memo'

  memo_id = params['memo_id'].to_i
  memo = @memos.find { |m| m['memo_id'] == memo_id }

  @memo_id = memo_id
  @memo_title = memo['memo_title']
  @memo_description = memo['memo_description']

  erb :edit
end

# 編集処理
patch '/memos/:memo_id' do
  memo_id = params['memo_id'].to_i

  @memos.each do |m|
    next unless m['memo_id'] == memo_id

    m['memo_title'] = params['memo_title']
    m['memo_description'] = params['memo_description']
    break
  end

  File.open(JSON_PATH, 'w') { |file| file.write(JSON.pretty_generate(@memos)) }

  redirect "/memos/#{memo_id}"
end

# 削除処理
delete '/memos/:memo_id' do
  memo_id = params['memo_id'].to_i
  @memos.delete_if { |m| m['memo_id'] == memo_id }

  File.open(JSON_PATH, 'w') { |file| file.write(JSON.pretty_generate(@memos)) }

  redirect '/'
end
