defmodule DailyUtilsWeb.HeaderLive do
  use DailyUtilsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  def render(assigns) do
    Phoenix.View.render(DailyUtilsWeb.LayoutView, "header.html", assigns)
  end

end
