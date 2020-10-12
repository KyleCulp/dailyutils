defmodule DailyUtils.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias DailyUtils.Repo

  alias DailyUtils.Todos.TodoList
  alias DailyUtils.Todos
  alias DailyUtils.Users.User

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(DailyUtils.PubSub, @topic)
  end

  defp broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(DailyUtils.PubSub, @topic, {__MODULE__, event, result})

    {:ok, result}
  end

  @doc """
  Returns the list of todo_lists.

  ## Examples

      iex> list_todo_lists()
      [%TodoList{}, ...]

  """
  def list_todo_lists do
    Repo.all(TodoList)
  end

  @doc """
  Returns the users list of todo_lists.

  ## Examples

      iex> list_user_todo_lists()
      [%TodoList{}, ...]

  """
  def list_user_todo_lists(user_id) do
    user =
      User
      |> where([user], user.id == ^user_id)
      |> join(:left, [user], todo_lists in assoc(user, :todo_lists))
      |> join(:left, [user, todo_lists], todo_items in assoc(todo_lists, :todo_items))
      |> preload([user, todo_lists, todo_items], todo_lists: {todo_lists, todo_items: todo_items})
      |> Repo.one()

    # Repo.get_by(TodoList, user_id: user_id)
    # Repo.all(from tl in TodoList, where: tl.user_id = ^user_id)
  end

  @doc """
  Gets a single todo_list.

  Raises `Ecto.NoResultsError` if the Todo list does not exist.

  ## Examples

      iex> get_todo_list!(123)
      %TodoList{}

      iex> get_todo_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo_list!(id) do
    todo_list =
      TodoList
      |> where([todo_list], todo_list.id == ^id)
      |> join(:left, [todo_lists], todo_items in assoc(todo_lists, :todo_items))
      |> preload([todo_lists, todo_items], todo_items: todo_items)
      |> Repo.one()
  end

  @spec create_todo_list(
          :invalid
          | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: any
  @doc """
  Creates a todo_list.

  ## Examples

      iex> create_todo_list(%{field: value})
      {:ok, %TodoList{}}

      iex> create_todo_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo_list(attrs \\ %{}) do
    %TodoList{}
    |> TodoList.changeset(attrs)
    |> Repo.insert()
    |> broadcast_change([:todo_list, :created])
  end

  @doc """
  Updates a todo_list.

  ## Examples

      iex> update_todo_list(todo_list, %{field: new_value})
      {:ok, %TodoList{}}

      iex> update_todo_list(todo_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo_list(%TodoList{} = todo_list, attrs) do
    todo_list
    |> TodoList.changeset(attrs)
    |> Repo.update()
    |> broadcast_change([:todo_list, :updated])
  end

  @doc """
  Deletes a todo_list.

  ## Examples

      iex> delete_todo_list(todo_list)
      {:ok, %TodoList{}}

      iex> delete_todo_list(todo_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo_list(%TodoList{} = todo_list) do
    todo_list
      |> Repo.delete()
      |> broadcast_change([:todo_list, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo_list changes.

  ## Examples

      iex> change_todo_list(todo_list)
      %Ecto.Changeset{data: %TodoList{}}

  """
  def change_todo_list(%TodoList{} = todo_list, attrs \\ %{}) do
    TodoList.changeset(todo_list, attrs)
  end

  alias DailyUtils.Todos.TodoItem

  @doc """
  Returns the list of todo_items.

  ## Examples

      iex> list_todo_items()
      [%TodoItem{}, ...]

  """
  def list_todo_items do
    Repo.all(TodoItem)
  end

  @doc """
  Gets a single todo_item.

  Raises `Ecto.NoResultsError` if the Todo item does not exist.

  ## Examples

      iex> get_todo_item!(123)
      %TodoItem{}

      iex> get_todo_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo_item!(id),
    do:
      todo_item =
        TodoItem
        |> where([todo_item], todo_item.id == ^id)
        |> join(:left, [u], _ in assoc(u, :todo_list))
        |> preload([_, p], todo_list: p)
        |> Repo.one()

  # |> Repo.get!(TodoItem, id)

  #     user = Blog.User
  # |> where([user], user.id == ^user_id)
  # |> join(:left, [u], _ in assoc(u, :posts))
  # |> join(:left, [_, posts], _ in assoc(posts, :comments))
  # |> preload([_, p, c], [posts: {p, comments: c}])
  # |> Blog.Repo.one

  @doc """
  Creates a todo_item.

  ## Examples

      iex> create_todo_item(%{field: value})
      {:ok, %TodoItem{}}

      iex> create_todo_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo_item(attrs \\ %{}) do
    %TodoItem{}
    |> TodoItem.changeset(attrs)
    |> Repo.insert()
    |> broadcast_change([:todo_item, :created])
  end

  @doc """
  Updates a todo_item.

  ## Examples

      iex> update_todo_item(todo_item, %{field: new_value})
      {:ok, %TodoItem{}}

      iex> update_todo_item(todo_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo_item(%TodoItem{} = todo_item, attrs) do
    todo_item
    |> TodoItem.changeset(attrs)
    |> Repo.update()
    |> broadcast_change([:todo_item, :updated])
  end

  @doc """
  Deletes a todo_item.

  ## Examples

      iex> delete_todo_item(todo_item)
      {:ok, %TodoItem{}}

      iex> delete_todo_item(todo_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo_item(%TodoItem{} = todo_item) do
    todo_item
      |> Repo.delete()
      |> broadcast_change([:todo_item, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo_item changes.

  ## Examples

      iex> change_todo_item(todo_item)
      %Ecto.Changeset{data: %TodoItem{}}

  """
  def change_todo_item(%TodoItem{} = todo_item, attrs \\ %{}) do
    TodoItem.changeset(todo_item, attrs)
  end
end
