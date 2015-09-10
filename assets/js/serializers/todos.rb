require 'models/todo'
require 'json'

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
