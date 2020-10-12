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
      </form>
    <% end %>
    </div>
    """
  end

  def update(assigns, socket) do
    todo_list = Todos.get_todo_list!(assigns.todo_list_id)
    # user = Repo.get! User, assigns.id
    {:ok, assign(socket, :todo_list, todo_list)}
  end

  # def preload(list_of_assigns) do
  #   list_of_ids = Enum.map(list_of_assigns, & &1.id)

  #   users =
  #     from(tl in TodoList, where: tl.id in ^list_of_ids, select: {tl.id, tl})
  #     |> Repo.all()
  #     |> Map.new()

  #   Enum.map(list_of_assigns, fn assigns ->
  #     Map.put(assigns, :todo_list, users[assigns.id])
  #   end)

  # end

  def handle_event("update_completed", %{"completed" => completed}, socket) do
    # Phoenix.PubSub.broadcast(DailyUtils.PubSub, board_topic(socket), message)
    {:noreply, socket}
  end

end
