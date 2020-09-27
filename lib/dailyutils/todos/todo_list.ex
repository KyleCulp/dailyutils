defmodule DailyUtils.Todos.TodoList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_lists" do
    field :name, :string
    field :color, :string
    belongs_to :user, DailyUtils.Users.User
    has_many :todo_items, DailyUtils.Todos.TodoItem

    timestamps()
  end

  @doc false
  def changeset(todo_list, attrs) do
    todo_list
    |> cast(attrs, [:name, :color, :user_id])
    |> validate_required([:name])
  end
end
