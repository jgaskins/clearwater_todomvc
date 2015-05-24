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
