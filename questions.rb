require_relative 'questionsdatabases'
require_relative 'users'
require_relative 'replies'
require_relative 'questionlikes'
require_relative 'questionfollowers'


class Question
  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
    FROM questions
    WHERE questions.id = ?
    SQL

    question = QuestionsDatabase.instance.execute(query, id)
    Question.initialize_with_id(question[0]) unless question.empty?
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
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
      questions << Question.initialize_with_id(question[0])
    end
    questions
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  attr_reader :id, :title, :body, :user_id

  def initialize(question_hash)
    #@id = question_hash['id']
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

  def followers
    QuestionsFollower.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  def save(title, body, user_id)
    if @id.nil?
      QuestionsDatabase.instance.execute(
        "INSERT INTO questions (title, body, user_id) VALUES (?,?,?)", title, body, user_id)
      @title = title
      @body = body
      @user_id = user_id
      @id = QuestionsDatabase.instance.execute(
        "SELECT last_insert_rowid()")[0]['last_insert_rowid()']

    else
      update = <<-SQL
      UPDATE questions
      SET title = ?, body = ?, user_id = ?
      WHERE id = ?
      SQL

      QuestionsDatabase.instance.execute(update, title, body, user_id, @id)
      @title = title
      @body = body
      @user_id = user_id
      return @id
    end
  end



  def id=(value)
    @id = value
  end


  private

  def self.initialize_with_id(question_hash)
    question = Question.new(question_hash)
    question.id = question_hash["id"]
    question
  end


end