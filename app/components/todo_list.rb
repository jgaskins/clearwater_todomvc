require 'components/todo_item'

class TodoList
  include Clearwater::Component

  attr_reader :todo_repo

  def initialize todo_repo
    @todo_repo = todo_repo
  end

  def render
    section({ id: 'main' }, [
      input(
        id: 'toggle-all',
        type: 'checkbox',
        onchange: method(:toggle_all),
        checked: todos.none?(&:active?)
      ),
      ul({ id: 'todo-list' }, todo_items),
    ])
  end

  def todos
    todo_repo.to_a
  end

  def toggle_all event
    todos.each do |todo|
      todo.toggle! event.target.checked?
    end

    todo_repo.save!
    call
  end

  def todo_items
    if @todo_items && @todo_items.map(&:key) == todos.map(&:id)
      return @todo_items 
    end

    @todo_items = todos.map { |todo|
      TodoItem.new(todo, todo_repo)
    }
  end
end
