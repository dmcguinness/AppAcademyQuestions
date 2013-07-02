require_relative 'questionsdatabases'

class Reply
  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
    FROM replies
    WHERE replies.id = ?
    SQL

    reply = QuestionsDatabase.instance.execute(query, id)
    reply.empty? ? nil : Reply.new(reply[0])
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
      replies << Reply.new(reply_hash)
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
      replies << Reply.new(reply_hash)
    end
    replies
  end


  attr_reader :id, :title, :body, :question_id, :user_id, :reply_id

  def initialize(reply_hash)
    @id = reply_hash['id']
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
end