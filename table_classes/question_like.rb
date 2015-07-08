require_relative '../modules/data_module'
require_relative '../modules/class_method_module'


class QuestionLike
  attr_reader :id, :question_id, :user_id

  include DataModule
  extend FindById

  def self.likers_for_question_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      users.*
    FROM
      questionlikes
    JOIN
      users ON questionlikes.user_id = users.id
    WHERE
       questionlikes.question_id = ?
    SQL

    results.map { |result| User.find_by_id(result['id'])}
  end

  def self.num_likes_for_question_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id).first
    SELECT
      COUNT(id) count
    FROM
      questionlikes
    WHERE
      question_id = ?
    GROUP BY
      question_id
    SQL

    result.nil? ? 0 : result["count"]
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      questionlikes
    JOIN
      questions ON questions.id = questionlikes.question_id
    WHERE
      questionlikes.user_id = ?
    SQL

    results.map { |result| Question.find_by_id(result['id'])}
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*
    FROM
      questionlikes
    JOIN
      questions ON questions.id = questionlikes.question_id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(questionlikes.id) DESC
    LIMIT ?
    SQL

    results.map { |result| Question.find_by_id(result['id'])}
  end

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end
