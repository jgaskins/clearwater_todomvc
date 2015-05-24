class TodoItem
  include Clearwater::Component

  attr_reader :todo, :todo_list

  def initialize todo, todo_list
    @todo = todo
    @todo_list = todo_list
  end

  def todo_class
    [
      ('completed' if todo.completed?),
      ('editing' if editing?),
    ].compact.join(' ')
  end

  def render
    li({ key: key, class_name: todo_class }, [
      if editing?
        input(class_name: 'edit', default_value: todo.name, onkeydown: method(:handle_edit_key_down), autofocus: true)
      else
        div({ class_name: 'view' }, [
          input(class_name: 'toggle', type: 'checkbox', checked: todo.completed?, onchange: method(:toggle_todo)),
          label({ ondblclick: method(:edit_todo) }, todo.name),
          button({ class_name: 'destroy', onclick: method(:delete_todo) }),
        ])
      end,
    ])
  end

  def key
    todo.id
  end

  def toggle_todo
    todo.toggle!
    todo_list.save!
    call
  end

  def edit_todo
    @editing = true
    call
  end

  def editing?
    !!@editing
  end

  def done_editing!
    @editing = false
    todo_list.save!
    call
  end

  def delete_todo
    todo_list.delete todo
    call
  end

  def handle_edit_key_down event
    case event.code
    when 13 # Enter
      todo.name = event.target.value
      done_editing!
    when 27 # Esc
      done_editing!
    end
  end
end
