defmodule DailyUtilsWeb.TodoListLive.Index do
  use DailyUtilsWeb, :live_view

  alias DailyUtils.Users
  alias DailyUtils.Todos
  alias DailyUtils.Todos.TodoList

  @impl true
  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(:todo_lists, list_todo_lists())
      |> assign(:current_user, Users.get_user!(1))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo list")
    |> assign(:todo_list, Todos.get_todo_list!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo list")
    |> assign(:todo_list, %TodoList{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todo lists")
    |> assign(:todo_list, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo_list = Todos.get_todo_list!(id)
    {:ok, _} = Todos.delete_todo_list(todo_list)

    {:noreply, assign(socket, :todo_lists, list_todo_lists())}
  end

  defp list_todo_lists do
    Todos.list_todo_lists()
  end
end
