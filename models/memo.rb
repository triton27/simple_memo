require 'pg'
require 'yaml'

class Memo
  @db_connect = nil

  attr_reader :id
  attr_accessor :title, :description

  def initialize(id = nil, title = nil, description = nil)
    @id = id.to_i
    @title = title
    @description = description
  end

  def self.db_connect
    @db_connect ||= begin
      file_path = File.expand_path('../config/database.yml', __dir__)
      dbconf = YAML.load_file(file_path)['db']
      PG.connect(dbconf)
    end
  end

  def self.close_connection
    @db_connect&.close
  end

  at_exit do
    close_connection
  end

  def self.execute_query(query, params = [], returning: false)
    connect = db_connect
    result = connect.exec_params(query, params)
    returning ? result : nil
  end

  def self.read_memos
    result = execute_query('SELECT * FROM memos', [], returning: true)

    result.map do |row|
      Memo.new(row['id'], row['title'], row['description'])
    end
  end

  def self.read_memo(id)
    query = 'SELECT * FROM memos WHERE id = $1 LIMIT 1'
    memo = execute_query(query, [id],  returning: true)

    row = memo[0]
    Memo.new(id, row['title'], row['description'])
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
