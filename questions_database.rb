require 'singleton'
require 'sqlite3'
require_relative 'table_classes/user'
require_relative 'table_classes/question'
require_relative 'table_classes/question_follow'
require_relative 'table_classes/reply'
require_relative 'table_classes/question_like'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end


end
