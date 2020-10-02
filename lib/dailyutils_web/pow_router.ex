defmodule DailyUtilsWeb.PowRouter do
  @moduledoc false

  use Pow.Phoenix.Routes

  # alias DailyUtilsWeb.Router.Helpers, as: Routes

  @landing_pages ~w[/]

  def after_sign_in_path(%{assigns: %{request_path: path}}) when path not in @landing_pages,
    do: path

  def after_sign_in_path(conn), do: Routes.user_index_path(conn, :index)
  # do: redirect(conn, to: Routes.user_index_path(conn, :index))
end
