require 'serializers/todos'

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
