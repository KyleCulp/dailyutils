defmodule DailyUtilsWeb.TodosLive.Index do
  use DailyUtilsWeb, :live_view
  # use Phoenix.LiveView

  # alias DailyUtils.Users
  alias DailyUtils.Todos
  alias DailyUtils.Todos.TodoList
  alias DailyUtilsWeb.TodosView

  #   def mount(params, session, socket) do
  #   case connected?(socket) do
  #     true -> connected_mount(params, session, socket)
  #     false -> {:ok, assign(socket, page: "loading")}
  #   end
  # end

  # def render(assigns), do: TodosView.render("index.html", assigns)

  # @impl Phoenix.LiveView
  # @impl true
  # def mount(params, session, socket) do
  #   case connected?(socket) do
  #     true -> connected_mount(params, session, socket)
  #     false -> {:ok, assign(socket, page: "loading")}
  #   end

  #   # socket =
  #   #   socket
  #   #   |> assign(:todo_lists, Todos.list_user_todo_lists(session.user_id))
  #   #   |> assign(:current_user, Users.get_user!(1))

  #   # {:ok, socket}
  # end

  def mount(_params, %{"user_id" => user_id}, socket) do
    user = Todos.list_user_todo_lists(user_id)
    # user = Repo.get(User, user_id)
    # socket =
    #   socket
    #   |> assign(todo_lists, todo_lists)

    # |> assign(:current_user, Users.get_user!(1))

    {:ok, assign(socket, user: user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Todo list")
  #   |> assign(:todo_list, Todos.get_todo_list!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Todo list")
  #   |> assign(:todo_list, %TodoList{})
  # end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todo lists")

    # |> assign(:todo_list, nil)
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
