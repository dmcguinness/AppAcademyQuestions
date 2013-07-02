require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  # Ruby provides a `Singleton` module that will only let one
  # `SchoolDatabase` object get instantiated. This is useful, because
  # there should only be a single connection to the database; there
  # shouldn't be multiple simultaneous connections. A call to
  # `SchoolDatabase::new` will result in an error. To get access to the
  # *single* SchoolDatabase instance, we call `#instance`.
  #
  # Don't worry too much about `Singleton`; it has nothing
  # intrinsically to do with SQL.
  include Singleton

  def initialize
    # tell the SQLite3::Database the db file to read/write
    super("aa_questions.db")

    # otherwise each row is returned as an array of values; we want a
    # hash indexed by column name.
    self.results_as_hash = true

    # otherwise all the data is returned as strings and not parsed
    # into the appropriate type.
    self.type_translation = true
  end
end

def get_users
  QuestionsDatabase.instance.execute("SELECT * FROM users")
end

def add_user(fname,lname)
  QuestionsDatabase.instance.execute(
    "INSERT INTO users (fname, lname) VALUES (?,?)", fname, lname)
end

def get_questions
  QuestionsDatabase.instance.execute("SELECT * FROM questions")
end


def add_questions(title, body, user_id)
  QuestionsDatabase.instance.execute(
    "INSERT INTO questions (title, body, user_id) VALUES (?, ?, ?)",
    title, body, user_id
  )
end

def get_question_followers
  QuestionsDatabase.instance.execute("SELECT * FROM question_followers")
end


def add_question_followers(question_id, user_id)
  QuestionsDatabase.instance.execute(
    "INSERT INTO question_followers (question_id, user_id) VALUES ( ?, ?)",
    question_id, user_id
  )
end

def get_replies
  QuestionsDatabase.instance.execute("SELECT * FROM replies")
end


def add_replies(title, body, question_id, user_id, reply_id)
  QuestionsDatabase.instance.execute(
    "INSERT INTO replies (title, body, question_id, user_id, reply_id)
    VALUES ( ?, ?, ?, ?, ?)",
    title, body, question_id, user_id, reply_id
  )
end

def get_question_likes
  QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
end


def add_question_likes(question_id, user_id)
  QuestionsDatabase.instance.execute(
    "INSERT INTO question_likes (question_id, user_id) VALUES ( ?, ?)",
    question_id, user_id
  )
end






