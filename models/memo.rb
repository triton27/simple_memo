require 'json'

class Memo
  attr_accessor :id, :title, :description

  JSON_PATH = 'public/memos.json'.freeze

  def self.read_memos
    memos = []
    JSON.load_file(JSON_PATH).each do |m|
      memos << Memo.new(m['id'], m['title'], m['description'])
    end

    memos
  end

  def self.read_memo(id)
    memos = read_memos
    memo = memos.find { |m| m.id == id }

    Memo.new(id, memo.title, memo.description)
  end

  # memos: Memoオブジェクトが入ったリスト
  def self.write_memos(memos)
    memos_list = []
    memos.each do |m|
      memos_hash = {
        id: m.id,
        title: m.title,
        description: m.description
      }
      memos_list << memos_hash
    end

    File.open(JSON_PATH, 'w') { |file| file.write(memos_list.to_json) }
  end

  def initialize(id = nil, title = nil, description = nil)
    @id = id
    @title = title
    @description = description
  end
end
