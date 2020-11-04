defmodule DailyUtilsWeb.TodosLive.Index do
  use DailyUtilsWeb, :live_view
  # use Phoenix.LiveView

  # alias DailyUtils.Users
  alias DailyUtils.Todos
  alias DailyUtils.Todos.TodoList
  alias DailyUtilsWeb.TodosView

  def render(assigns) do
    Phoenix.View.render(DailyUtilsWeb.TodosView, "index.html", assigns)
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    user = Todos.list_user_todo_lists(user_id)
    assigns = [
      current_user: user,
      todo_lists: user.todo_lists,
      changeset: TodoList.changeset(%TodoList{}, %{user_id: user_id})
    ]
    Todos.subscribe()
    {:ok, assign(socket, assigns)}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Todo Lists")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo List")
	end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Todo Lists")
	end

  @impl true
  def handle_event("add_todo_list", %{"todo_list" => todo_list}, socket) do
    Todos.create_todo_list(todo_list)

    {:noreply, socket}
  end

  def handle_info({Todos, [:todo_list | _], _}, socket) do
  {:noreply, socket}
end



  # defp apply_action(socket, :show, %{"id" => id}) d
  #   todo_list = Todos.get_todo_list!(id)

  #   socket
  #   |> assign(:page_title, todo_list.name)
  #   |> assign(:todo_list, todo_list)

  #   Phoenix.View.render(DailyUtilsWeb.TodosView, "show.html", socket)
  # end

end
