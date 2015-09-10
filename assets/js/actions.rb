require 'grand_central'

module Actions
  include GrandCentral

  AddTodo = Action.with_attributes :todo
  ToggleTodo = Action.with_attributes :todo
  DeleteTodo = Action.with_attributes :todo
  EditTodo = Action.with_attributes :todo
  RenameTodo = Action.with_attributes :todo, :name
  DoneEditingTodo = Action.with_attributes :todo

  ClearCompletedTodos = Class.new(Action)
  ToggleAllTodos = Action.with_attributes :completed
end
