require 'opal'
require 'clearwater'
require 'grand_central'
require 'set'

require 'components/layout'
require 'components/active_todo_list'
require 'components/completed_todo_list'
require 'components/todo_list_wrapper'
require 'repositories/todo'
require 'actions'
require 'store'

router = Clearwater::Router.new do
  route 'active' => TodoListWrapper.new(ActiveTodoList)
  route 'completed' => TodoListWrapper.new(CompletedTodoList)
end

App = Clearwater::Application.new(
  component: Layout.new,
  router: router,
  element: Bowser.document['#todoapp']
)

Store.on_dispatch do |old, new|
  unless old.equal? new
    TodoRepository.new(Store.state[:todos]).save!
    App.render
  end
end

App.call
