require 'clearwater/application'
require 'json'

require 'components/layout'
require 'components/active_todo_list'
require 'components/completed_todo_list'
require 'repositories/todo'

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
