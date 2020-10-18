defmodule DailyUtilsWeb.TodosLive.Show do
  use DailyUtilsWeb, :live_view
  # use Phoenix.LiveView

  # alias DailyUtils.Users
  alias DailyUtils.Todos
  alias DailyUtils.Todos.TodoList
  alias DailyUtils.Todos.TodoItem
  alias DailyUtilsWeb.TodosView

  def render(assigns) do
    Phoenix.View.render(DailyUtilsWeb.TodosView, "show.html", assigns)
  end

  def mount(%{"id" => id}, %{"user_id" => user_id}, socket) do
    user = Todos.list_user_todo_lists(user_id)
    todo_list = Todos.get_todo_list!(id)
    Todos.subscribe()

    assigns = [
      current_user: user,
      todo_list: todo_list,
      todo_item_changeset: TodoItem.changeset(%TodoItem{}, %{todo_list_id: todo_list.id}),
      page_title: todo_list.name
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  @spec handle_params(map, any, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     #  |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:todo_list, Todos.get_todo_list!(id))}
  end

  def handle_event("add_todo_item", %{"todo_item" => todo_item}, socket) do
    Todos.create_todo_item(todo_item)

    {:noreply, socket}
  end

  def handle_event("toggle_completed", %{"id" => id}, socket) do
    # Todos.update_todo_item(todo_item)
    todo_item = Todos.get_todo_item!(id)
    Todos.update_todo_item(todo_item, %{completed: !todo_item.completed})
    {:noreply, socket}
  end



  # def handle_info({Todos, [:todo_list | _], _}, socket) do
  #   {:noreply, fetch(socket)}
  # end

end
