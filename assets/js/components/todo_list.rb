require 'components/todo_item'

TodoList = Struct.new(:store) do
  include Clearwater::Component

  def render
    section({ id: 'main' }, [
      input(
        id: 'toggle-all',
        type: 'checkbox',
        onchange: method(:toggle_all),
        checked: todos.all?(&:completed?)
      ),
      ul({ id: 'todo-list' }, todo_items),
    ])
  end

  def todos
    store.state[:todos]
  end

  def toggle_all event
    store.dispatch Actions::ToggleAllTodos.new
  end

  def todo_items
    todos.map { |todo| TodoItem.new(todo, store) }
  end
end
