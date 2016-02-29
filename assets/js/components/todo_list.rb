require 'components/todo_item'

class TodoList
  include Clearwater::Component
  include Clearwater::CachedRender

  attr_reader :todos, :editing_todos

  def initialize todos, editing_todos
    @todos = todos
    @editing_todos = editing_todos
  end

  def should_render? previous
    !(
      todos.equal?(previous.todos) &&
      editing_todos.equal?(previous.editing_todos)
    )
  end

  def render
    section({ id: 'main' }, [
      input(
        id: 'toggle-all',
        type: 'checkbox',
        onchange: method(:toggle_all),
        checked: todos.all? { |t| t.completed? },
      ),
      ul({ id: 'todo-list' }, todo_items),
    ])
  end

  def toggle_all event
    Store.dispatch Actions::ToggleAllTodos.new event.target.checked?
  end

  def todo_items
    todos.map { |todo|
      editing = editing_todos.include?(todo)

      li({ key: todo.id, class_name: todo_class(todo.completed?, editing) }, [
        TodoItem.new(todo, editing)
      ])
    }
  end

  def todo_class completed, editing
    [
      ('completed' if completed),
      ('editing' if editing),
    ].compact.join(' ')
  end
end
