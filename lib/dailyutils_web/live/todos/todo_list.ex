defmodule DailyUtilsWeb.TodosLive.TodoList do
  use DailyUtilsWeb, :live_component

  # alias DailyUtils.Users
  alias DailyUtils.Todos
  alias DailyUtils.Todos.TodoList
  alias DailyUtilsWeb.TodosView

  def render(assigns) do
    ~L"""
    <div id="todo_list_<%= @todo_list.id %>" class="flex flex-col w-full">
    <%= for todo_item <- @todo_list.todo_items do %>
      <div id="todo_item_<%= todo_item.id %>">
        <div class="text-gray-700 bg-gray-400 px-4 py-2 m-2 .align-middle">
          <label class=".align-middle inline-flex items-center mt-3">
          <input type="checkbox" class=".align-middle form-checkbox h-5 w-5 text-gray-600" <%= if todo_item.completed do %>checked<% end %>>
            <span class="ml-2 text-gray-700"><%= todo_item.name %></span>
          </label>
        </div>
      </div>
    <% end %>
    </div>
    """
  end
end
