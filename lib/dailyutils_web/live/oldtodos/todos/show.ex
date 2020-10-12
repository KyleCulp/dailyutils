defmodule DailyUtilsWeb.TodosLive.Show do
  use DailyUtilsWeb, :live_view
  # use Phoenix.LiveView

  # alias DailyUtils.Users
  alias DailyUtils.Todos
  alias DailyUtils.Todos.TodoList
  alias DailyUtilsWeb.TodosView

  def render(assigns) do
    Phoenix.View.render(DailyUtilsWeb.TodosView, "show.html", assigns)
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    user = Todos.list_user_todo_lists(user_id)
    Todos.subscribe()
    {:ok, assign(socket, current_user: user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     #  |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:todo_list, Todos.get_todo_list!(id))}
  end

  # def handle_info({Todos, [:todo_list | _], _}, socket) do
  #   {:noreply, fetch(socket)}
  # end

end
