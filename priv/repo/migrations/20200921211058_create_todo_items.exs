defmodule DailyUtils.Repo.Migrations.CreateTodoItems do
  use Ecto.Migration

  def change do
    create table(:todo_items) do
      add :name, :string
      add :completed, :boolean, default: false, null: false

      add :todo_list_id,
          references(:todo_lists, on_delete: :delete_all)

      timestamps()
    end

    create index(:todo_items, [:todo_list_id])
  end
end
