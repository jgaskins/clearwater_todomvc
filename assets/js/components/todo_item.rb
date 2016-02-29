class TodoItem
  include Clearwater::Component
  include Clearwater::CachedRender

  attr_reader :todo

  def initialize todo, editing
    @todo = todo
    @editing = editing
  end

  def should_render? previous
    !(
      todo.equal?(previous.todo) &&
      editing? == previous.editing?
    )
  end

  def render
    div([
      if editing?
        input(
          class_name: 'edit',
          default_value: todo.name,
          onkeydown: method(:handle_edit_key_down),
          autofocus: true,
        )
      else
        div({ class_name: 'view' }, [
          input(
            class_name: 'toggle',
            type: 'checkbox',
            checked: todo.completed?,
            onchange: method(:toggle_todo),
          ),
          label({ ondblclick: method(:edit_todo) }, todo.name),
          button({ class_name: 'destroy', onclick: method(:delete_todo) }),
        ])
      end,
    ])
  end

  def toggle_todo
    Store.dispatch Actions::ToggleTodo.new(todo)
  end

  def edit_todo
    Store.dispatch Actions::EditTodo.new(todo)
  end

  def editing?
    @editing
  end

  def done_editing!
    Store.dispatch Actions::DoneEditingTodo.new(todo)
  end

  def delete_todo
    Store.dispatch Actions::DeleteTodo.new(todo)
  end

  def handle_edit_key_down event
    case event.code
    when 13 # Enter
      Store.dispatch Actions::RenameTodo.new(todo, event.target.value)
      done_editing!
    when 27 # Esc
      done_editing!
    end
  end
end
