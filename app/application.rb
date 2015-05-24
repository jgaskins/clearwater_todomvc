require 'clearwater/application'
require 'json'

module Browser
  module DOM
    class Element
      class Input
        def checked?
          `#@native.checked`
        end
      end
    end
  end
end

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

class ActiveTodoList < TodoList
  def todos
    super.select(&:active?)
  end
end

class CompletedTodoList < TodoList
  def todos
    super.select(&:completed?)
  end
end

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
        input(class_name: 'edit', default_value: todo.name, onkeydown: method(:handle_edit_key_down))
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

class Todo
  attr_reader :id
  attr_accessor :name

  def initialize(name, completed: false)
    @id = rand
    @name = name
    @completed = completed
  end

  def completed?
    !!@completed
  end

  def active?
    !completed?
  end

  def toggle! value=!completed?
    @completed = value
  end
end

class TodosSerializer
  attr_reader :todos

  def initialize todos
    @todos = todos
  end

  def to_json
    todos.map { |todo|
      {
        id: todo.id,
        name: todo.name,
        completed: todo.completed?,
      }
    }.to_json
  end

  def self.from_json json
    hashes = JSON.parse(json)
    todos = hashes.map do |hash|
      todo = Todo.allocate
      hash.each do |attr, value|
        todo.instance_variable_set "@#{attr}", value
      end

      todo
    end

    new(todos)
  end
end

class TodoRepository
  include Enumerable

  attr_reader :todos

  def load!
    @todos = TodosSerializer.from_json(`localStorage.todos || '[]'`).todos
  end

  def save!
    %x{ localStorage.todos = #{TodosSerializer.new(todos).to_json} }
  end

  def each &block
    todos.each &block
  end

  def reject! &block
    todos.reject! &block
    save!
  end

  def << todo
    todos << todo
    save!
  end
end

todo_repo = TodoRepository.new
todo_repo.load!

router = Clearwater::Router.new do
  route 'active' => ActiveTodoList.new(todo_repo)
  route 'completed' => CompletedTodoList.new(todo_repo)
end

App = Clearwater::Application.new(
  component: Layout.new(todo_repo),
  router: router,
  element: $document['#todoapp']
)

App.call
