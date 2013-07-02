require_relative 'questionsdatabases'
require_relative 'questions'
require_relative 'users'
require_relative 'replies'
require_relative 'questionlikes'
require_relative 'questionfollowers'



class Tag

  def self.most_popular
    query = <<-SQL
    SELECT
      q.id question_id,
      tags.tag tag
    FROM (
      SELECT
        questions.id,
        COUNT(question_likes.id) AS count
      FROM questions LEFT
      JOIN question_likes ON questions.id = question_likes.question_id
      GROUP BY questions.id
      ) AS q
    JOIN tags on tags.question_id = q.id
    GROUP BY tags.id
    HAVING q.count = MAX(q.count)
    SQL

    pop_question_array = QuestionsDatabase.instance.execute(query)
    popular_tag_hash = {}
    pop_question_array.each do |pop_question_hash|
      popular_tag_hash[pop_question_hash['tag']] = Question.find_by_id(pop_question_hash['question_id'])
    end

    popular_tag_hash
  end


  def initialize(tag_hash)
    @tags = tag_hash['tag']
    @question_id = tag_hash['question_id']
  end

end