defmodule RoadchatWeb.Router do
  use RoadchatWeb, :router

  import RoadchatWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RoadchatWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_authenticated do
    # guardian functions
    plug Roadchat.AuthAccessPipeline
  end

  scope "/", RoadchatWeb do
    pipe_through :browser

    get "/", PageController, :home
  end


  scope "/api/v1", RoadchatWeb, as: :api do
    pipe_through :api

    post "/users/register", Api.V1.UserRegistrationController, :create
    post "/users/login", Api.V1.UserSessionController, :create

    post "/users/reset_password", Api.V1.ResetPasswordController, :send_reset_token
    get "/users/reset_password/:token", Api.V1.ResetPasswordController, :show_reset_form

  end

  scope "/api/v1", RoadchatWeb, as: :api do
    pipe_through [:api, :api_authenticated]

    get "/posts", API.V1.PostController, :index
    get "/refresh", API.V1.PostController, :refresh
    post "/posts", API.V1.PostController, :create
    get "/userdetails/:id", API.V1.ProfileController, :userdetails
    post "/userdetails/:id", API.V1.ProfileController, :update

        # create
        # post "/sale", API.V1.SaleController, :create
        # get "/sales", API.V1.SaleController, :index
        # get "/sale/:id", API.V1.SaleController, :get_sale
        # put "/sale/:id", API.V1.SaleController, :update_sale

        get "/users/:id", API.V1.ListUserController, :index

        # get comments
        get "/comments/:id", API.V1.CommentController, :index
        post "/comment", API.V1.CommentController, :create

        post "/commentcount", API.V1.PostController, :comment_count

        # post "/like", PostController, :like_post
        # post "/unlike", PostController, :unlike_post

        resources "/cards", API.V1.CustomerCardController

        get "/customercards/:id", API.V1.CustomerCardController, :get_card
        get "/details_by_paymentmethod/:payment_method_id", API.V1.CustomerCardController, :get_card_details_by_paymentmethod

        get "/getloggedinusers/:id", API.V1.LoggedinUsersController, :get_users_in_range
        post "/loggedinuser", API.V1.LoggedinUsersController, :user_logged_in
        post "/loggedoutuser", API.V1.LoggedinUsersController, :user_logged_out
        post "/updategeo", API.V1.LoggedinUsersController, :update_geo_position
        get "/istokenvalid", API.V1.LoggedinUsersController, :is_token_valid


  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:roadchat, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RoadchatWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", RoadchatWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{RoadchatWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", RoadchatWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{RoadchatWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", RoadchatWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{RoadchatWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
