require 'pg'
require 'yaml'

class Memo
  attr_reader :id
  attr_accessor :title, :description

  def initialize(id = nil, title = nil, description = nil)
    @id = id.to_i
    @title = title
    @description = description
  end

  def self.db_connect
    file_path = File.expand_path('../config/database.yml', __dir__)
    dbconf = YAML.load_file(file_path)['db']
    PG::Connection.new(dbconf)
  end

  def self.execute_query(query, params = [], returning: false)
    connect = db_connect
    result = connect.exec_params(query, params)
    connect.finish
    returning ? result : nil
  end

  def self.read_memos
    result = execute_query('SELECT * FROM memos', [], returning: true)

    result.map do |row|
      Memo.new(row['id'], row['title'], row['description'])
    end
  end

  def self.read_memo(id)
    memos = read_memos
    memo = memos.find { |m| m.id == id }

    Memo.new(id, memo.title, memo.description)
  end

  def self.insert_memo(memo)
    query = 'INSERT into memos VALUES ($1, $2, $3)'
    execute_query(query, [memo.id, memo.title, memo.description])
  end

  def self.update_memo(memo)
    query = 'UPDATE memos SET title = $1, description = $2 WHERE id = $3'
    execute_query(query, [memo.title, memo.description, memo.id])
  end

  def self.delete_memo(memo)
    query = 'DELETE FROM memos WHERE id = $1'
    execute_query(query, [memo.id])
  end
end
