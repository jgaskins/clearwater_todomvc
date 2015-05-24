require 'components/todo_list'

class Layout
  include Clearwater::Component

  attr_reader :todo_repo

  def initialize todo_repo=[]
    @todo_repo = todo_repo
  end

  def render
    div(nil, [
      header({ id: 'header' }, [
        h1(nil, 'todos'),
        input(id: 'new-todo', placeholder: 'What needs to be done?', onkeydown: method(:handle_new_todo_key_down), autofocus: true),
      ]),

      (outlet || todo_list),

      footer,
    ])
  end

  def todo_list
    @todo_list ||= TodoList.new(todo_repo)
  end

  def add_todo name
    todo_repo << Todo.new(name)
    call
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
    active_count = todo_repo.count(&:active?)

    tag('footer#footer', nil, [
      span({ id: 'todo-count' }, [
        strong(nil, active_count),
        " todo#{'s' unless active_count == 1} left"
      ]),
      ul({ id: 'filters' }, [
        li(nil, Link.new({ href: '/' }, 'All')),
        li(nil, Link.new({ href: '/active' }, 'Active')),
        li(nil, Link.new({ href: '/completed' }, 'Completed')),
      ]),
      clear_button
    ])
  end

  def clear_button
    button({ id: 'clear-completed', onclick: method(:clear_completed) }, 'Clear completed')
  end

  def clear_completed
    todo_repo.reject!(&:completed?)
    call
  end
end
