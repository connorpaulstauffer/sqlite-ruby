require_relative '../modules/data_module'
require_relative '../modules/class_method_module'
class QuestionLike
  attr_reader :id, :question_id, :user_id

  include DataModule

  def self.likers_for_question_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      users.*
    FROM
      question_likes
    JOIN
      users ON question_likes.user_id = users.id
    WHERE
       question_likes.question_id = ?
    SQL
    return nil if results.empty?

    results.map { |result| User.find_by_id(result['id'])}
  end

  def self.num_likes_for_question_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id).first
    SELECT
      COUNT(id) count
    FROM
      question_likes
    WHERE
      question_id = ?
    GROUP BY
      question_id
    SQL
    return 0 if result.nil?
    result["count"]
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      question_likes
    JOIN
      questions ON questions.id = question_likes.question_id
    WHERE
      question_likes.user_id = ?
    SQL
    return nil if results.empty?
    results.map { |result| Question.find_by_id(result['id'])}
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*
    FROM
      question_likes
    JOIN
      questions ON questions.id = question_likes.question_id
    GROUP BY
      questions.id
    ORDER BY
      count(question_likes.id) DESC
    LIMIT ?
    SQL
    return nil if results.empty?
    results.map { |result| Question.find_by_id(result['id'])}
  end

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  extend FindById
end
