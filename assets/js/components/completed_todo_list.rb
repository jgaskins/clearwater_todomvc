require 'components/todo_list'

class CompletedTodoList < TodoList
  def todos
    super.select(&:completed?)
  end
end
