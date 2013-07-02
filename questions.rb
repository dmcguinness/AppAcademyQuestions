require_relative 'questionsdatabases'
require_relative 'users'

class Question
  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
    FROM questions
    WHERE questions.id = ?
    SQL

    question = QuestionsDatabase.instance.execute(query, id)
    question.empty? ? nil : Question.new(question[0])
  end

  def self.find_by_author_id(id)
    query = <<-SQL
      SELECT *
    FROM questions
    WHERE questions.user_id = ?
    SQL

    question = QuestionsDatabase.instance.execute(query, id)

    questions = []
    question.each do |question_hash|
      questions << Question.new(question_hash)
    end
    questions
  end

  attr_reader :id, :title, :body, :user_id

  def initialize(question_hash)
    @id = question_hash['id']
    @title = question_hash['title']
    @body = question_hash['body']
    @user_id = question_hash['user_id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end
end