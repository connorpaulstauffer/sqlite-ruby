require_relative '../modules/data_module'
require_relative '../modules/class_method_module'


class User
  attr_reader :id
  attr_accessor :fname, :lname

  include DataModule
  extend FindById

  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname).first
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? AND lname = ?
    SQL

    result.nil? ? nil : User.new(result)
  end

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_author_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      CAST(COUNT(questionlikes.id) AS FLOAT) / COUNT(DISTINCT(questions.id)) avg
    FROM
      questions
    LEFT JOIN
      questionlikes ON questionlikes.question_id = questions.id
    WHERE
      questions.author_id = ?
    SQL

    result.nil? ? 0 : result.first['avg']
  end
end
