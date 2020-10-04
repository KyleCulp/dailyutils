defmodule DailyUtilsWeb.Router do
  use DailyUtilsWeb, :router
  use Pow.Phoenix.Router

  use Pow.Extension.Phoenix.Router,
    otp_app: :dailyutils,
    extensions: [PowResetPassword, PowPersistentSession]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {DailyUtilsWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler

    plug DailyUtilsWeb.AssignUser
  end

  pipeline :not_authenticated do
    plug Pow.Plug.RequireNotAuthenticated,
      error_handler: DailyUtilsWeb.AuthErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()
  end

  # scope "/", DailyUtilsWeb do
  #   pipe_through [:browser, :not_authenticated]

  #   get "/signup", RegistrationController, :new, as: :signup
  #   post "/signup", RegistrationController, :create, as: :signup
  #   get "/login", SessionController, :new, as: :login
  #   post "/login", SessionController, :create, as: :login
  # end

  scope "/", DailyUtilsWeb do
    pipe_through :browser

    get "/signup", RegistrationController, :new, as: :signup
    post "/signup", RegistrationController, :create, as: :signup
    get "/login", SessionController, :new, as: :login
    post "/login", SessionController, :create, as: :login
    delete "/logout", SessionController, :delete, as: :logout

    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit

    live "/users/:id", UserLive.Show, :show
    live "/users/:id/show/edit", UserLive.Show, :edit

    # live "/", PageLive, :index
  end

  scope "/", DailyUtilsWeb do
    pipe_through [:browser, :protected]
    live "/", PageLive
    live "/todos", TodosLive.Index, :index
    live "/todos/:id", TodosLive.Index, :show
    # live "/todo_lists", TodoListLive.Index, :index
    # live "/todo_lists/new", TodoListLive.Index, :new
    # live "/todo_lists/:id/edit", TodoListLive.Index, :edit

    # live "/todo_lists/:id", TodoListLive.Show, :show
    # live "/todo_lists/:id/show/edit", TodoListLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", DailyUtilsWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: DailyUtilsWeb.Telemetry
    end
  end
end
