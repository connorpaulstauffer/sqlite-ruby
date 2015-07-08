require_relative '../modules/data_module'
require_relative '../modules/class_method_module'


class Reply
  attr_reader :id, :question_id, :parent_id, :user_id
  attr_accessor :body

  include DataModule
  extend FindById

  def self.find_by_parent_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      parent_id = ?
    SQL
    return nil if results.empty?
    results.map { |result| Reply.new(result) }
  end

  def self.find_by_user_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?
    SQL

    return nil if results.empty?
    results.map { |result| Reply.new(result)}
  end

  def self.find_by_question_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL

    return nil if results.empty?
    results.map { |result| Reply.new(result) }
  end

  def initialize(options = {})
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
  end

  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_id(parent_id)
  end

  def child_replies
    Reply.find_by_parent_id(id)
  end
end
