initial_state = {
  todos: TodoRepository.new.load!,
  editing_todos: Set.new,
}

Store = GrandCentral::Store.new(initial_state) do |state, action|
  case action
  when Actions::AddTodo
    state.merge todos: state[:todos] + [action.todo]
  when Actions::ToggleTodo
    state.merge todos: state[:todos].map { |todo|
      if todo == action.todo
        todo.toggled
      else
        todo
      end
    }
  when Actions::DeleteTodo
    state.merge todos: state[:todos] - [action.todo]
  when Actions::RenameTodo
    state.merge todos: state[:todos].map { |todo|
      if todo == action.todo
        todo.update name: action.name
      else
        todo
      end
    }
  when Actions::EditTodo
    state.merge editing_todos: state[:editing_todos] + [action.todo]
  when Actions::DoneEditingTodo
    state.merge editing_todos: state[:editing_todos] - [action.todo]
  when Actions::ToggleAllTodos
    state.merge todos: state[:todos].map { |todo|
      todo.toggled action.completed
    }
  when Actions::ClearCompletedTodos
    state.merge todos: state[:todos].reject(&:completed?)
  else
    state
  end
end
