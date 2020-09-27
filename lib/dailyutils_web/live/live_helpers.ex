defmodule DailyUtilsWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `DailyUtilsWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, DailyUtilsWeb.TodoListLive.FormComponent,
        id: @todo_list.id || :new,
        action: @live_action,
        todo_list: @todo_list,
        return_to: Routes.todo_list_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, DailyUtilsWeb.ModalComponent, modal_opts)
  end
end
