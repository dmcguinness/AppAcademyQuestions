require_relative 'questionsdatabases'
require_relative 'questions'
require_relative 'users'
require_relative 'questionlikes'
require_relative 'questionfollowers'


class Reply
  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
    FROM replies
    WHERE replies.id = ?
    SQL

    reply = QuestionsDatabase.instance.execute(query, id)
    Reply.initialize_with_id(reply[0]) unless reply.empty?
  end

  def self.find_by_question_id(id)
    replies = []
    query = <<-SQL
      SELECT *
    FROM replies
    WHERE replies.question_id = ?
    SQL

    reply_array = QuestionsDatabase.instance.execute(query, id)
    reply_array.each do |reply_hash|
      replies << Reply.initialize_with_id(reply_hash)
    end
    replies
  end

  def self.find_by_user_id(id)
    replies = []
    query = <<-SQL
      SELECT *
    FROM replies
    WHERE replies.user_id = ?
    SQL

    reply_array = QuestionsDatabase.instance.execute(query, id)
    reply_array.each do |reply_hash|
      replies << Reply.initialize_with_id(reply_hash)
    end
    replies
  end


  attr_reader :id, :title, :body, :question_id, :user_id, :reply_id

  def initialize(reply_hash)
    #@id = reply_hash['id']
    @title = reply_hash['title']
    @body = reply_hash['body']
    @question_id = reply_hash['question_id']
    @user_id = reply_hash['user_id']
    @reply_id = reply_hash['replies_id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@replies_id) unless @reply_id.nil?
  end

  def child_replies
    query =  <<-SQL
    SELECT *
    FROM replies
    WHERE replies.reply_id = ?
    SQL

    replies = QuestionsDatabase.instance.execute(query, @id)

    child_replies = []

    replies.each do |child_hash|
      child_replies << Reply.new(child_hash)
    end

    child_replies
  end

  def save(title,body, question_id, user_id, reply_id)
    if @id.nil?
      QuestionsDatabase.instance.execute(
        "INSERT INTO replies (title, body, question_id, user_id, reply_id) VALUES (?,?,?,?,?)", title, body, question_id, user_id, reply_id)
      @title = title
      @body = body
      @question_id = question_id
      @user_id = user_id
      @reply_id = reply_id
      @id =  QuestionsDatabase.instance.execute(
        "SELECT last_insert_rowid()")[0]['last_insert_rowid()']

    else
      update = <<-SQL
      UPDATE replies
      SET title = ?, body = ?, question_id = ?, user_id = ?, reply_id = ?
      WHERE id = ?
      SQL

      QuestionsDatabase.instance.execute(update, title, body, question_id, user_id, reply_id, @id)
      @title = title
      @body = body
      @question_id = question_id
      @user_id = user_id
      @reply_id = reply_id
      return @id
    end
  end

  def id=(value)
    @id = value
  end

  private

  def self.initialize_with_id(reply_hash)
    reply = Reply.new(reply_hash)
    reply.id = reply_hash["id"]
    reply
  end

end