defmodule DailyUtilsWeb.PowResetPassword.MailerView do
  use DailyUtilsWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
