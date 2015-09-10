require 'components/todo_list'

Layout = Struct.new(:store) do
  include Clearwater::Component

  def render
    div(nil, [
      header({ id: 'header' }, [
        h1(nil, 'todos'),
        input(
          id: 'new-todo',
          placeholder: 'What needs to be done?',
          onkeydown: method(:handle_new_todo_key_down),
          autofocus: true
        ),
      ]),

      (outlet || todo_list),

      footer,
    ])
  end

  def todo_list
    @todo_list ||= TodoList.new(store)
  end

  def add_todo name
    store.dispatch Actions::AddTodo.new(Todo.new(name))
  end

  def handle_new_todo_key_down event
    case event.code
    when 13 # Enter/Return
      add_todo(event.target.value)
      event.target.clear
    when 27 # Esc
      event.target.clear
    end
  end

  def footer
    active_count = store.state[:todos].count(&:active?)

    tag('footer#footer', nil, [
      span({ id: 'todo-count' }, [
        strong(nil, active_count),
        " todo#{'s' unless active_count == 1} left"
      ]),
      ul({ id: 'filters' }, [
        li(Link.new({ href: '/' }, 'All')),
        li(Link.new({ href: '/active' }, 'Active')),
        li(Link.new({ href: '/completed' }, 'Completed')),
      ]),
      clear_button
    ])
  end

  def clear_button
    button({ id: 'clear-completed', onclick: method(:clear_completed) }, 'Clear completed')
  end

  def clear_completed
    store.dispatch Actions::ClearCompletedTodos.new
  end
end
