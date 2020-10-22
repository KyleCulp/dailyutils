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
    Todos.subscribe()
    user = Todos.list_user_todo_lists(user_id)
    todo_list = Todos.get_todo_list!(id)

    assigns = [
      current_user: user,
      todo_list: todo_list,
      changeset: TodoItem.changeset(%TodoItem{}, %{todo_list_id: todo_list.id}),
      page_title: todo_list.name
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
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

  def handle_event("validate", %{"todo_item" => new_todo_item}, socket) do
    # Todos.update_todo_item(todo_item)
    changeset =
      %TodoItem{}
      |> Todos.update_todo_item(new_todo_item)

    {:noreply, assign(socket, changeset: changeset)}
  end


  def handle_info({Todos, [:todo_item | _], _}, socket) do
    {:noreply, socket}
  end
  # defp schedule_save() do
  #   Process.send_after(self(), :store, 10 * 1_000)
  # end

  # # Receives periodic pings from itself?
  # def handle_info(:store, socket) do
  #   {:ok, todo_item} = Todos.update_todo_item(socket.assigns.changeset)
  #   schedule_save()
  #   {
  #     :noreply,
  #     socket
  #     |> assign(:changeset, Todos.update_todo_item(todo_item))
  #     # |> assign(:todo_list, todo_item)
  #   }
  # end

  # def terminate(_reason, socket) do
  #   {:ok, %TodoItem{}} = Todos.update_todo_item(socket.assigns.changeset)
  #   :ok
  # end


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
