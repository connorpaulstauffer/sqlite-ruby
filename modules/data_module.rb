module DataModule

  def save
    instance_var_str = instance_variables.drop(1).map { |str| str[1..-1] }
    instance_var_values = instance_var_str.map { |var| self.send(var) }

    if id.nil?
      new_entry(instance_var_str, instance_var_values)
    else
      update_entry(instance_var_str, instance_var_values)
    end
    self
  end

  def new_entry(instance_var_str, instance_var_values)
    table_name = self.class.to_s.downcase + 's'

    list_of_vars = instance_var_str.join(', ')
    question_mark_string = (['?'] * (instance_var_str.count)).join(',')
    QuestionsDatabase.instance.execute(<<-SQL, *instance_var_values)
    INSERT INTO
      #{table_name} (#{list_of_vars})
    VALUES
      (#{question_mark_string})
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update_entry(instance_var_str, instance_var_values)
    table_name = self.class.to_s.downcase + 's'

    var_value_mapping = instance_var_str.map.with_index do |var, idx|
      var + " = " + instance_var_values[idx].inspect
    end.join(', ')
    QuestionsDatabase.instance.execute(<<-SQL, self.id)
    UPDATE
      #{table_name}
    SET
      #{var_value_mapping}
    WHERE
      id = ?
    SQL
  end

end
