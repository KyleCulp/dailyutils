defmodule DailyUtilsWeb.TodoListLive.FormComponent do
  use DailyUtilsWeb, :live_component

  alias DailyUtils.Todos

  @impl true
  def update(%{todo_list: todo_list} = assigns, socket) do
    changeset = Todos.change_todo_list(todo_list)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"todo_list" => todo_list_params}, socket) do
    changeset =
      socket.assigns.todo_list
      |> Todos.change_todo_list(todo_list_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"todo_list" => todo_list_params}, socket) do
    save_todo_list(socket, socket.assigns.action, todo_list_params)
  end

  defp save_todo_list(socket, :edit, todo_list_params) do
    case Todos.update_todo_list(socket.assigns.todo_list, todo_list_params) do
      {:ok, _todo_list} ->
        {:noreply,
         socket
         |> put_flash(:info, "Todo list updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_todo_list(socket, :new, todo_list_params) do
    case Todos.create_todo_list(todo_list_params) do
      {:ok, _todo_list} ->
        {:noreply,
         socket
         |> put_flash(:info, "Todo list created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
