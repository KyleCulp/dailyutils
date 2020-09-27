defmodule DailyUtils.PowMailer do
  use Pow.Phoenix.Mailer
  use Bamboo.Mailer, otp_app: :dailyutils

  import Bamboo.Email

  @impl true
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new_email(
      to: user.email,
      from: "myapp@example.com",
      subject: subject,
      html_body: html,
      text_body: text
    )
  end

  @impl true
  def process(email) do
    # An asynchronous process should be used here to prevent enumeration
    # attacks. Synchronous e-mail delivery can reveal whether a user already
    # exists in the system or not.

    deliver_later(email)
  end
end
