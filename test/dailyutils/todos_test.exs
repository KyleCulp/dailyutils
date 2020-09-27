defmodule DailyUtils.TodosTest do
  use DailyUtils.DataCase

  alias DailyUtils.Todos

  describe "todo_lists" do
    alias DailyUtils.Todos.TodoList

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def todo_list_fixture(attrs \\ %{}) do
      {:ok, todo_list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Todos.create_todo_list()

      todo_list
    end

    test "list_todo_lists/0 returns all todo_lists" do
      todo_list = todo_list_fixture()
      assert Todos.list_todo_lists() == [todo_list]
    end

    test "get_todo_list!/1 returns the todo_list with given id" do
      todo_list = todo_list_fixture()
      assert Todos.get_todo_list!(todo_list.id) == todo_list
    end

    test "create_todo_list/1 with valid data creates a todo_list" do
      assert {:ok, %TodoList{} = todo_list} = Todos.create_todo_list(@valid_attrs)
      assert todo_list.name == "some name"
    end

    test "create_todo_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo_list(@invalid_attrs)
    end

    test "update_todo_list/2 with valid data updates the todo_list" do
      todo_list = todo_list_fixture()
      assert {:ok, %TodoList{} = todo_list} = Todos.update_todo_list(todo_list, @update_attrs)
      assert todo_list.name == "some updated name"
    end

    test "update_todo_list/2 with invalid data returns error changeset" do
      todo_list = todo_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo_list(todo_list, @invalid_attrs)
      assert todo_list == Todos.get_todo_list!(todo_list.id)
    end

    test "delete_todo_list/1 deletes the todo_list" do
      todo_list = todo_list_fixture()
      assert {:ok, %TodoList{}} = Todos.delete_todo_list(todo_list)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo_list!(todo_list.id) end
    end

    test "change_todo_list/1 returns a todo_list changeset" do
      todo_list = todo_list_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo_list(todo_list)
    end
  end

  describe "todo_items" do
    alias DailyUtils.Todos.TodoItem

    @valid_attrs %{completed: true, name: "some name"}
    @update_attrs %{completed: false, name: "some updated name"}
    @invalid_attrs %{completed: nil, name: nil}

    def todo_item_fixture(attrs \\ %{}) do
      {:ok, todo_item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Todos.create_todo_item()

      todo_item
    end

    test "list_todo_items/0 returns all todo_items" do
      todo_item = todo_item_fixture()
      assert Todos.list_todo_items() == [todo_item]
    end

    test "get_todo_item!/1 returns the todo_item with given id" do
      todo_item = todo_item_fixture()
      assert Todos.get_todo_item!(todo_item.id) == todo_item
    end

    test "create_todo_item/1 with valid data creates a todo_item" do
      assert {:ok, %TodoItem{} = todo_item} = Todos.create_todo_item(@valid_attrs)
      assert todo_item.completed == true
      assert todo_item.name == "some name"
    end

    test "create_todo_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo_item(@invalid_attrs)
    end

    test "update_todo_item/2 with valid data updates the todo_item" do
      todo_item = todo_item_fixture()
      assert {:ok, %TodoItem{} = todo_item} = Todos.update_todo_item(todo_item, @update_attrs)
      assert todo_item.completed == false
      assert todo_item.name == "some updated name"
    end

    test "update_todo_item/2 with invalid data returns error changeset" do
      todo_item = todo_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo_item(todo_item, @invalid_attrs)
      assert todo_item == Todos.get_todo_item!(todo_item.id)
    end

    test "delete_todo_item/1 deletes the todo_item" do
      todo_item = todo_item_fixture()
      assert {:ok, %TodoItem{}} = Todos.delete_todo_item(todo_item)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo_item!(todo_item.id) end
    end

    test "change_todo_item/1 returns a todo_item changeset" do
      todo_item = todo_item_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo_item(todo_item)
    end
  end
end
