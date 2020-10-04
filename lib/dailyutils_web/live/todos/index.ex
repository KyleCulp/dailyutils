defmodule DailyUtilsWeb.TodosLive.Index do
  use DailyUtilsWeb, :live_view
  # use Phoenix.LiveView

  # alias DailyUtils.Users
  alias DailyUtils.Todos
  alias DailyUtils.Todos.TodoList
  alias DailyUtilsWeb.TodosView

  @spec mount(any, map, Phoenix.LiveView.Socket.t()) :: {:ok, any}

  def mount(_params, %{"user_id" => user_id}, socket) do
    user = Todos.list_user_todo_lists(user_id)

    {:ok, assign(socket, current_user: user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Todo Lists")
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    todo_list = Todos.get_todo_list!(id)

    socket
    |> assign(:page_title, todo_list.name)
    |> assign(:todo_list, todo_list)
  end

  defp list_todo_lists do
    Todos.list_todo_lists()
  end
end
