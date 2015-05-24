require 'components/todo_list'

class ActiveTodoList < TodoList
  def todos
    super.select(&:active?)
  end
end
