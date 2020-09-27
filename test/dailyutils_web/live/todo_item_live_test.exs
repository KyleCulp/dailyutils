defmodule DailyUtilsWeb.TodoItemLiveTest do
  use DailyUtilsWeb.ConnCase

  import Phoenix.LiveViewTest

  alias DailyUtils.Todos

  @create_attrs %{completed: true, name: "some name"}
  @update_attrs %{completed: false, name: "some updated name"}
  @invalid_attrs %{completed: nil, name: nil}

  defp fixture(:todo_item) do
    {:ok, todo_item} = Todos.create_todo_item(@create_attrs)
    todo_item
  end

  defp create_todo_item(_) do
    todo_item = fixture(:todo_item)
    %{todo_item: todo_item}
  end

  describe "Index" do
    setup [:create_todo_item]

    test "lists all todo_items", %{conn: conn, todo_item: todo_item} do
      {:ok, _index_live, html} = live(conn, Routes.todo_item_index_path(conn, :index))

      assert html =~ "Listing Todo items"
      assert html =~ todo_item.name
    end

    test "saves new todo_item", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.todo_item_index_path(conn, :index))

      assert index_live |> element("a", "New Todo item") |> render_click() =~
               "New Todo item"

      assert_patch(index_live, Routes.todo_item_index_path(conn, :new))

      assert index_live
             |> form("#todo_item-form", todo_item: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#todo_item-form", todo_item: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.todo_item_index_path(conn, :index))

      assert html =~ "Todo item created successfully"
      assert html =~ "some name"
    end

    test "updates todo_item in listing", %{conn: conn, todo_item: todo_item} do
      {:ok, index_live, _html} = live(conn, Routes.todo_item_index_path(conn, :index))

      assert index_live |> element("#todo_item-#{todo_item.id} a", "Edit") |> render_click() =~
               "Edit Todo item"

      assert_patch(index_live, Routes.todo_item_index_path(conn, :edit, todo_item))

      assert index_live
             |> form("#todo_item-form", todo_item: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#todo_item-form", todo_item: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.todo_item_index_path(conn, :index))

      assert html =~ "Todo item updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes todo_item in listing", %{conn: conn, todo_item: todo_item} do
      {:ok, index_live, _html} = live(conn, Routes.todo_item_index_path(conn, :index))

      assert index_live |> element("#todo_item-#{todo_item.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#todo_item-#{todo_item.id}")
    end
  end

  describe "Show" do
    setup [:create_todo_item]

    test "displays todo_item", %{conn: conn, todo_item: todo_item} do
      {:ok, _show_live, html} = live(conn, Routes.todo_item_show_path(conn, :show, todo_item))

      assert html =~ "Show Todo item"
      assert html =~ todo_item.name
    end

    test "updates todo_item within modal", %{conn: conn, todo_item: todo_item} do
      {:ok, show_live, _html} = live(conn, Routes.todo_item_show_path(conn, :show, todo_item))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Todo item"

      assert_patch(show_live, Routes.todo_item_show_path(conn, :edit, todo_item))

      assert show_live
             |> form("#todo_item-form", todo_item: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#todo_item-form", todo_item: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.todo_item_show_path(conn, :show, todo_item))

      assert html =~ "Todo item updated successfully"
      assert html =~ "some updated name"
    end
  end
end
