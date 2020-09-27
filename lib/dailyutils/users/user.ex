defmodule DailyUtils.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowPersistentSession]

  schema "users" do
    field :email, :string
    field :admin, :boolean
    has_many :todo_lists, DailyUtils.Todos.TodoList

    pow_user_fields()
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)

    # |> unique_constraint(:email)
  end
end
