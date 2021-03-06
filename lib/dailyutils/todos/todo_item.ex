defmodule DailyUtils.Todos.TodoItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_items" do
    field :completed, :boolean, default: false
    field :name, :string
    belongs_to :todo_list, DailyUtils.Todos.TodoList

    timestamps()
  end

  @doc false
  def changeset(todo_item, attrs) do
    todo_item
    |> cast(attrs, [:name, :completed, :todo_list_id])
    |> validate_required([:name, :completed, :todo_list_id])
    |> foreign_key_constraint(:todo_list_id)
    |> validate_length(:name, min: 1)
  end
end
