require_relative 'questionsdatabases'

class QuestionLikes
  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
      FROM question_likes
    WHERE question_likes.id = ?
    SQL

    question_like = QuestionsDatabase.instance.execute(query, id)
    question_like.empty? ? nil : QuestionLikes.new(question_like[0])
  end

  attr_reader :id, :question_id, :user_id

  def initialize(question_like_hash)
    @id = question_like_hash['id']
    @question_id = question_like_hash['question_id']
    @user_id = question_like_hash['user_id']
  end
end