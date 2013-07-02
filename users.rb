require_relative 'questionsdatabases'
require_relative 'questions'
require_relative 'replies'

class User
  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
    FROM users
    WHERE users.id = ?
    SQL

    user = QuestionsDatabase.instance.execute(query, id)
    user.empty? ? nil : User.new(user[0])
  end

  def self.find_by_name(fname, lname)
    query = <<-SQL
      SELECT *
    FROM users
    WHERE users.fname = ? AND users.lname = ?
    SQL

    user = QuestionsDatabase.instance.execute(query, fname, lname)
    user.empty? ? nil : User.new(user[0])
  end

  attr_reader :id, :fname, :lname

  def initialize(user_hash)
    @id = user_hash['id']
    @fname = user_hash['fname']
    @lname = user_hash['lname']

  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end
end