require 'opal'
require 'clearwater'
require 'grand_central'
require 'set'

require 'components/layout'
require 'components/active_todo_list'
require 'components/completed_todo_list'
require 'repositories/todo'
require 'actions'
require 'store'

router = Clearwater::Router.new do
  route 'active' => ActiveTodoList.new(Store)
  route 'completed' => CompletedTodoList.new(Store)
end

App = Clearwater::Application.new(
  component: Layout.new(Store),
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
