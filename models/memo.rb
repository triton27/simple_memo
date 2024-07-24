require 'json'

class Memo
  attr_accessor :memo_id, :memo_title, :memo_description

  JSON_PATH = 'public/memos.json'.freeze

  def self.read_memos
    JSON.load_file(JSON_PATH)
  end

  def self.write_memos(memos)
    File.open(JSON_PATH, 'w') { |file| file.write(JSON.pretty_generate(memos)) }
  end

  def initialize(memo_id)
    memos = self.class.read_memos
    memo = memos.find { |m| m['memo_id'] == memo_id }

    @memo_id = memo_id
    @memo_title = memo['memo_title']
    @memo_description = memo['memo_description']
  end
end
