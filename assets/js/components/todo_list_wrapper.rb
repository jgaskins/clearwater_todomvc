TodoListWrapper = Struct.new(:component_class) do
  include Clearwater::Component

  def render
    component_class.new(Store.state[:todos], Store.state[:editing_todos])
  end
end
