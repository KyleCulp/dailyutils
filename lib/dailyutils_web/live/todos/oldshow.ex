defmodule DailyUtilsWeb.TodosLive.Show do
  use DailyUtilsWeb, :live_view

  alias DailyUtils.Todos

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     #  |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:todo_list, Todos.get_todo_list!(id))}
  end

  defp page_title(:show), do: "Show Todo list"
  defp page_title(:edit), do: "Edit Todo list"
end
