TodoItem = Struct.new(:todo, :store) do
  include Clearwater::Component

  def render
    li({ key: key, class_name: todo_class }, [
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

  def todo_class
    [
      ('completed' if todo.completed?),
      ('editing' if editing?),
    ].compact.join(' ')
  end

  def key
    todo.id
  end

  def toggle_todo
    store.dispatch Actions::ToggleTodo.new(todo)
  end

  def edit_todo
    store.dispatch Actions::EditTodo.new(todo)
  end

  def editing?
    store.state[:editing_todos].include?(todo)
  end

  def done_editing!
    store.dispatch Actions::DoneEditingTodo.new(todo)
  end

  def delete_todo
    store.dispatch Actions::DeleteTodo.new(todo)
  end

  def handle_edit_key_down event
    case event.code
    when 13 # Enter
      store.dispatch Actions::RenameTodo.new(todo, event.target.value)
      done_editing!
    when 27 # Esc
      done_editing!
    end
  end
end
