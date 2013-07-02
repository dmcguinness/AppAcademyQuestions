require_relative 'questionsdatabases'
require_relative 'questions'
require_relative 'replies'
require_relative 'questionlikes'
require_relative 'questionfollowers'
require_relative 'tags'


class User
  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
    FROM users
    WHERE users.id = ?
    SQL

    user_array = QuestionsDatabase.instance.execute(query, id)
    user = User.new(user_array[0]) unless user_array.empty?
  end

  def self.find_by_name(fname, lname)
    query = <<-SQL
      SELECT *
    FROM users
    WHERE users.fname = ? AND users.lname = ?
    SQL

    user_array = QuestionsDatabase.instance.execute(query, fname, lname)
    user = User.new(user_array[0]) unless user_array.empty?
  end

  attr_reader :id, :fname, :lname

  def initialize(user_hash)
    #@id = user_hash['id']
    @fname = user_hash['fname']
    @lname = user_hash['lname']
    find_id
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollower.followers_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def find_id
    query = <<-SQL
    SELECT id
    FROM users
    WHERE fname = ?
    AND lname = ?
    SQL
    id_array = QuestionsDatabase.instance.execute(query, fname, lname)
    if id_array.empty?
      @id = nil
    else
      id_hash = id_array[0]
      @id = id_hash["id"]
    end
  end

  def average_karma
    query = <<-SQL
        SELECT SUM(count)/COUNT(count) AS ave
        FROM (
          SELECT COUNT(question_likes.id) count
          FROM questions LEFT JOIN question_likes ON questions.id = question_likes.question_id
          WHERE questions.user_id = ?
          GROUP BY questions.id
        )
    SQL
    karma = QuestionsDatabase.instance.execute(query, @id)[0]
    karma['ave']
  end

  def save(fname,lname)

    @fname = fname
    @lname = lname
    if @id.nil?

      QuestionsDatabase.instance.execute(
        "INSERT INTO users (fname, lname) VALUES (?,?)", fname, lname)
      @id =  QuestionsDatabase.instance.execute(
        "SELECT last_insert_rowid()")[0]['last_insert_rowid()']
    else

      update = <<-SQL
      UPDATE users
      SET fname = ?, lname = ?
      WHERE id = ?
      SQL

      QuestionsDatabase.instance.execute(update, fname, lname, @id)
      return @id
    end
  end
end