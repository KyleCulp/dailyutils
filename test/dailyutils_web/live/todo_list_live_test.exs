defmodule DailyUtilsWeb.TodoListLiveTest do
  use DailyUtilsWeb.ConnCase

  import Phoenix.LiveViewTest

  alias DailyUtils.Todos

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp fixture(:todo_list) do
    {:ok, todo_list} = Todos.create_todo_list(@create_attrs)
    todo_list
  end

  defp create_todo_list(_) do
    todo_list = fixture(:todo_list)
    %{todo_list: todo_list}
  end

  describe "Index" do
    setup [:create_todo_list]

    test "lists all todo_lists", %{conn: conn, todo_list: todo_list} do
      {:ok, _index_live, html} = live(conn, Routes.todo_list_index_path(conn, :index))

      assert html =~ "Listing Todo lists"
      assert html =~ todo_list.name
    end

    test "saves new todo_list", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.todo_list_index_path(conn, :index))

      assert index_live |> element("a", "New Todo list") |> render_click() =~
               "New Todo list"

      assert_patch(index_live, Routes.todo_list_index_path(conn, :new))

      assert index_live
             |> form("#todo_list-form", todo_list: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#todo_list-form", todo_list: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.todo_list_index_path(conn, :index))

      assert html =~ "Todo list created successfully"
      assert html =~ "some name"
    end

    test "updates todo_list in listing", %{conn: conn, todo_list: todo_list} do
      {:ok, index_live, _html} = live(conn, Routes.todo_list_index_path(conn, :index))

      assert index_live |> element("#todo_list-#{todo_list.id} a", "Edit") |> render_click() =~
               "Edit Todo list"

      assert_patch(index_live, Routes.todo_list_index_path(conn, :edit, todo_list))

      assert index_live
             |> form("#todo_list-form", todo_list: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#todo_list-form", todo_list: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.todo_list_index_path(conn, :index))

      assert html =~ "Todo list updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes todo_list in listing", %{conn: conn, todo_list: todo_list} do
      {:ok, index_live, _html} = live(conn, Routes.todo_list_index_path(conn, :index))

      assert index_live |> element("#todo_list-#{todo_list.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#todo_list-#{todo_list.id}")
    end
  end

  describe "Show" do
    setup [:create_todo_list]

    test "displays todo_list", %{conn: conn, todo_list: todo_list} do
      {:ok, _show_live, html} = live(conn, Routes.todo_list_show_path(conn, :show, todo_list))

      assert html =~ "Show Todo list"
      assert html =~ todo_list.name
    end

    test "updates todo_list within modal", %{conn: conn, todo_list: todo_list} do
      {:ok, show_live, _html} = live(conn, Routes.todo_list_show_path(conn, :show, todo_list))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Todo list"

      assert_patch(show_live, Routes.todo_list_show_path(conn, :edit, todo_list))

      assert show_live
             |> form("#todo_list-form", todo_list: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#todo_list-form", todo_list: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.todo_list_show_path(conn, :show, todo_list))

      assert html =~ "Todo list updated successfully"
      assert html =~ "some updated name"
    end
  end
end
