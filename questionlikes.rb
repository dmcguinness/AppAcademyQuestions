require_relative 'questionsdatabases'
require_relative 'questions'
require_relative 'users'
require_relative 'replies'
require_relative 'questionfollowers'

class QuestionLike
  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
      FROM question_likes
    WHERE question_likes.id = ?
    SQL

    question_like = QuestionsDatabase.instance.execute(query, id)
    question_like.empty? ? nil : QuestionLike.new(question_like[0])
  end

  def self.likers_for_question_id(question_id)
    query = <<-SQL
    SELECT user_id
    FROM question_likes JOIN users ON question_likes.user_id = users.id
  WHERE question_likes.question_id = ?
    SQL

    question_likers = QuestionsDatabase.instance.execute(query, question_id)
    likers = []
    question_likers.each do |question_liker_hash|
      likers << User.find_by_id(question_liker_hash['user_id'])
    end
    likers
  end

  def self.num_likes_for_question_id(question_id)
    query = <<-SQL
    SELECT COUNT(question_likes.user_id) count
    FROM question_likes JOIN users ON question_likes.user_id = users.id
    WHERE question_likes.question_id = ?
    GROUP BY question_likes.question_id
    SQL
    question_liker_count = QuestionsDatabase.instance.execute(query, question_id)
    if question_liker_count.empty?
      0
    else
      question_liker_count[0]["count"] unless question_liker_count.empty?
    end
  end

  def self.liked_questions_for_user_id(user_id)
    query = <<-SQL
    SELECT question_id
    FROM question_likes JOIN questions ON question_likes.user_id = questions.user_id
    WHERE questions.user_id = ?
    SQL
    questions_liked_by_user = QuestionsDatabase.instance.execute(query, user_id)

    questions_liked = []
    questions_liked_by_user.each do |qu_id_hash|
      questions_liked << Question.find_by_id(qu_id_hash["question_id"])
    end

    questions_liked
  end


  def self.most_liked_questions(n)
    query = <<-SQL
    SELECT
         question_likes.question_id quest_id
        ,COUNT(question_likes.user_id) count
    FROM question_likes JOIN users ON question_likes.user_id = users.id
    GROUP BY question_likes.question_id
    ORDER BY count DESC
    SQL
    question_likes = QuestionsDatabase.instance.execute(query)

    top_liked_questions = []
    question_likes[0...n].each do |quest_hash|
      top_liked_questions << Question.find_by_id(quest_hash['quest_id'])
    end

    top_liked_questions
  end

  attr_reader :id, :question_id, :user_id

  def initialize(question_like_hash)
    @id = question_like_hash['id']
    @question_id = question_like_hash['question_id']
    @user_id = question_like_hash['user_id']
  end
end