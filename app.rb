require 'sinatra'
require 'sinatra/reloader'
require 'json'

JSON_PATH = 'public/memos.json'

before do
  @memos = JSON.load_file(JSON_PATH)
end

get '/' do
  @title = 'Top'
  erb :top
end

get '/new' do
  @title = 'New memo'
  erb :new
end

post '/' do
  new_memo = { 'memo_id' => @memos.max_by { |m| m['memo_id'] }['memo_id'] + 1,
               'memo_title' => params['memo_title'],
               'memo_description' => params['memo_description'] }

  @memos << new_memo

  File.open(JSON_PATH, 'w') { |file| file.write(JSON.pretty_generate(@memos)) }

  erb :top
end

get '/memos/:memo_id' do
  @title = 'Show memo'

  memo_id = params['memo_id'].to_i
  memo = @memos.find { |m| m['memo_id'] == memo_id }

  @memo_id = memo_id
  @memo_title = memo['memo_title']
  @memo_description = memo['memo_description']

  erb :show
end

get '/memos/:memo_id/edit' do
  @title = 'Edit memo'

  memo_id = params['memo_id'].to_i
  memo = @memos.find { |m| m['memo_id'] == memo_id }

  @memo_id = memo_id
  @memo_title = memo['memo_title']
  @memo_description = memo['memo_description']

  erb :edit
end

patch '/memos/:memo_id/edit' do
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
