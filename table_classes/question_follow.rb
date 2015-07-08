require_relative '../modules/data_module'
require_relative '../modules/class_method_module'
class QuestionFollow
  attr_reader :id, :question_id, :follower_id

  include DataModule

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      question_follows
    JOIN
      questions ON question_follows.question_id = questions.id
    JOIN
      users ON questions.author_id = users.id
    WHERE
      question_follows.question_id = ?
    SQL
    return nil if results.empty?
    results.map { |result| User.find_by_id(result['id'])}
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      question_follows
    JOIN
      questions ON question_follows.question_id = questions.id
    WHERE
      question_follows.question_id = ?
    SQL
    return nil if results.empty?
    results.map { |result| Question.find_by_id(result['id'])}
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*
    FROM
      question_follows
    JOIN
      questions ON question_follows.question_id = questions.id
    GROUP BY
      questions.id
    ORDER BY
      count(question_follows.id) DESC
    LIMIT ?
    SQL
    return nil if results.empty?
    results.map { |result| Question.find_by_id(result['id'])}
  end

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @follower_id = options['follower_id']
  end

  extend FindById
end
