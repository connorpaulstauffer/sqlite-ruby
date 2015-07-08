# require 'active-support/inflector'

module FindById
  def find_by_id(id)
    table_name = self.to_s.downcase + "s"
    # table_name = ActiveSupport::Inflector.pluralize(table)
    result = QuestionsDatabase.instance.execute(<<-SQL, id).first
    SELECT
      *
    FROM
     #{table_name}
    WHERE
      id = ?
    SQL
    return nil if result.nil?
    self.new(result)
  end
end
