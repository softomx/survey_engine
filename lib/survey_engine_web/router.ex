defmodule SurveyEngineWeb.Router do
  alias SurveyEngineWeb.ContextSession
  use SurveyEngineWeb, :router

  import SurveyEngineWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SurveyEngineWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :locale do
    plug SurveyEngineWeb.Plugs.Locale, "es"
  end

  pipeline :iframe do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SurveyEngineWeb.Layouts, :root}
    plug :protect_from_forgery
    plug SurveyEngineWeb.Plugs.AllowIframe
  end

  scope "/", SurveyEngineWeb do
    pipe_through :browser
  end

  # Other scopes may use custom stacks.
  scope "/api", SurveyEngineWeb do
    pipe_through :api

    post "/webhooks/:site_config/:provider", WebhookController, :index
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:survey_engine, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SurveyEngineWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", SurveyEngineWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :locale]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [
        {SurveyEngineWeb.UserAuth, :redirect_if_user_is_authenticated},
        {SurveyEngineWeb.ContextSession, :load_site_configuration},
        {ContextSession, :current_page},
        {ContextSession, :set_locale}
      ],
      layout: {SurveyEngineWeb.Layouts, :login} do
      live "/", UserLoginLive, :new

      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", SurveyEngineWeb do
    pipe_through [:browser, :locale]

    live_session :general,
      on_mount: [
        {SurveyEngineWeb.ContextSession, :load_site_configuration},
        {ContextSession, :current_page},
        {ContextSession, :set_locale}
      ],
      layout: {SurveyEngineWeb.Layouts, :login} do
      live "/policies", PolicyLive.Show, :show
    end
  end

  scope "/", SurveyEngineWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :locale]

    live_session :register,
      on_mount: [
        {SurveyEngineWeb.UserAuth, :redirect_if_user_is_authenticated},
        {SurveyEngineWeb.ContextSession, :load_site_configuration},
        {ContextSession, :current_page},
        {ContextSession, :set_locale}
      ],
      layout: {SurveyEngineWeb.Layouts, :register} do
      live "/users/register", UserRegistrationLive, :new
    end
  end

  scope "/", SurveyEngineWeb do
    pipe_through [:browser, :require_authenticated_user, :locale]

    live_session :require_authenticated_user,
      on_mount: [
        {SurveyEngineWeb.UserAuth, :ensure_authenticated},
        {SurveyEngineWeb.ContextSession, :load_site_configuration},
        {ContextSession, :current_page},
        {ContextSession, :set_locale}
      ] do
      live "/dashboard", CompanyLive.Index, :index
      live "/company", CompanyLive.Show, :show
      live "/company/edit", CompanyLive.Index, :edit

      get "/error", PageController, :home
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/business_model_form/:id/new", BusinessModelForm.New, :new

      live "/survey_responses", SurveyResponseLive.Index, :index
      live "/survey_responses/new", SurveyResponseLive.Index, :new
      live "/survey_responses/:id/edit", SurveyResponseLive.Index, :edit

      live "/survey_responses/:id", SurveyResponseLive.Show, :show
      live "/survey_responses/:id/show/edit", SurveyResponseLive.Show, :edit
    end
  end

  scope "/admin", SurveyEngineWeb do
    pipe_through [:browser, :require_authenticated_user, :locale]

    live_session :admin_authenticated_user,
      on_mount: [
        {SurveyEngineWeb.UserAuth, :ensure_authenticated},
        {SurveyEngineWeb.ContextSession, :load_site_configuration},
        {ContextSession, :current_page},
        {ContextSession, :set_locale}
      ] do
      live "/companies", AdminCompanyLive.Index, :index
      live "/companies/:id", AdminCompanyLive.Show, :show
      live "/companies/:id/assign", AdminCompanyLive.Edit, :assign
      live "/companies/:id/edit", AdminCompanyLive.Edit, :edit
      live "/catalogs/currencies", CurrencyLive.Index, :index
      live "/catalogs/currencies/new", CurrencyLive.Index, :new
      live "/catalogs/currencies/:id/edit", CurrencyLive.Index, :edit

      live "/catalogs/agency_types", AgencyTypeLive.Index, :index

      live "/catalogs/agency_types/new", AgencyTypeLive.Index, :new
      live "/catalogs/agency_types/:id/edit", AgencyTypeLive.Index, :edit

      live "/catalogs/business_models", BusinessModelLive.Index, :index
      live "/catalogs/business_models/new", BusinessModelLive.Index, :new
      live "/catalogs/business_models/:id/edit", BusinessModelLive.Index, :edit
      live "/catalogs/:type/:resource_id/translations/:behaviour", TranslationLive.Index, :index

      live "/catalogs/:type/:resource_id/translations/:behaviour/new",
           TranslationLive.New,
           :new

      live "/catalogs/:type/:resource_id/translations/:behaviour/:id/edit",
           TranslationLive.Edit,
           :edit

      live "/catalogs/:type/:resource_id/translations/:behaviour/:id",
           TranslationLive.Show,
           :show

      live "/catalogs/business_models/:business_model_id/business_configs",
           BusinessConfigLive.Index,
           :index

      live "/catalogs/business_models/:business_model_id/business_configs/new",
           BusinessConfigLive.Index,
           :new

      live "/catalogs/business_models/:business_model_id/business_configs/:id/edit",
           BusinessConfigLive.Index,
           :edit

      live "/catalogs/business_models/:business_model_id/business_configs/:id",
           BusinessConfigLive.Show,
           :show

      live "/catalogs/business_models/:business_model_id/business_configs/:id/show/edit",
           BusinessConfigLive.Show,
           :edit

      live "/catalogs/personal_titles", PersonalTitleLive.Index, :index
      live "/catalogs/personal_titles/new", PersonalTitleLive.Index, :new
      live "/catalogs/personal_titles/:id/edit", PersonalTitleLive.Index, :edit

      get "/error", PageController, :home
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/site_configurations", SiteConfigurationLive.Index, :index
      live "/site_configurations/new", SiteConfigurationLive.Index, :new
      live "/site_configurations/:id/edit", SiteConfigurationLive.Index, :edit

      live "/form_groups", FormGroupLive.Index, :index
      live "/form_groups/new", FormGroupLive.Index, :new
      live "/form_groups/:id/edit", FormGroupLive.Index, :edit

      live "/form_groups/:form_group_id/leads_forms", LeadsFormLive.Index, :index
      live "/form_groups/:form_group_id/leads_forms/responses", LeadsFormLive.Index, :index
      live "/form_groups/:form_group_id/leads_forms/new", LeadsFormLive.Index, :new
      live "/form_groups/:form_group_id/leads_forms/:id/edit", LeadsFormLive.Index, :edit

      live "/business_model_form/:id/new", BusinessModelForm.New, :new

      # sitecontext
      live "/mailer_config", MailerConfigLive.Index, :index

      live "/mailer_configs/:id/edit",
           MailerConfigLive.Index,
           :edit

      live "/mailer_configs/new",
           MailerConfigLive.Index,
           :new

      live "/content/:behaviour", SiteContentLive.Index, :index
      live "/content/:behaviour/new", SiteContentLive.New, :new
      live "/content/:behaviour/:id/edit", SiteContentLive.Edit, :edit
      live "/content/:behaviour/:id", SiteContentLive.Show, :show

      live "/notifications", NotificationLive.Index, :index
      live "/notifications/new", NotificationLive.New, :new
      live "/notifications/:id/edit", NotificationLive.Edit, :edit
      live "/notifications/:id", NotificationLive.Show, :show

      live "/reports/pre_registration", ReportLive.PreRegistration, :pre_registration

    end
  end

  scope "/", SurveyEngineWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [
        {SurveyEngineWeb.UserAuth, :mount_current_user},
        {ContextSession, :current_page},
        {ContextSession, :set_locale}
      ],
      layout: {SurveyEngineWeb.Layouts, :login} do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  scope "/embed", SurveyEngineWeb do
    pipe_through [:iframe, :locale]

    live_session :iframe,
      on_mount: [
        {SurveyEngineWeb.ContextSession, :load_site_configuration},
        {ContextSession, :current_page},
        {ContextSession, :set_locale}
      ],
      layout: {SurveyEngineWeb.Layouts, :iframe} do
      live "/users/register/form", EmbedLive.UserRegisterForm, :index
      live "/users/register/form/agencies_info", EmbedLive.UserRegisterForm, :modal_show
    end
  end
end
