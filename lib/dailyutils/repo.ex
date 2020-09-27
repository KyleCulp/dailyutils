defmodule DailyUtils.Repo do
  use Ecto.Repo,
    otp_app: :dailyutils,
    adapter: Ecto.Adapters.Postgres
end
