require_relative 'questionsdatabases'
require_relative 'questions'
require_relative 'users'
require_relative 'replies'
require_relative 'questionlikes'

class QuestionFollower
  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
    FROM question_followers
    WHERE question_followers.id = ?
    SQL

    question_followers = QuestionsDatabase.instance.execute(query, id)
    question_followers.empty? ? nil : QuestionFollower.new(question_followers[0])
  end

  def self.followers_for_question_id(id)
    query = <<-SQL
      SELECT *
    FROM question_followers JOIN questions on question_followers.question_id = questions.id
    WHERE questions.id = ?
    SQL

    question_followers = QuestionsDatabase.instance.execute(query, id)
    question_followers = []
    question_followers.each do |question_follower_hash|
      question_followers << QuestionFollower.new(question_follower_hash)
    end
    question_followers
  end

  attr_reader :id, :question_id, :user_id

  def initialize(question_followers_hash)
    @id = question_followers_hash['id']
    @question_id = question_followers_hash['question_id']
    @user_id = question_followers_hash['user_id']
  end
end