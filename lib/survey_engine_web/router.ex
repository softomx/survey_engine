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
    plug :put_root_layout, html: {SurveyEngineWeb.Layouts, :iframe}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug :allow_iframe
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
      live "/users/sucess_register", UserRegistrationSucessLive, :show
    end
  end

  scope "/", SurveyEngineWeb do
    pipe_through [:browser, :require_authenticated_user, :locale]

    live_session :require_authenticated_user,
      on_mount: [
        {SurveyEngineWeb.UserAuth, :ensure_authenticated},
        {SurveyEngineWeb.ContextSession, :load_site_configuration},
        {ContextSession, :current_page},
        {ContextSession, :set_locale},
        {ContextSession, :validate_route}
      ] do
      live "/dashboard", CompanyLive.Index, :index
      live "/company", CompanyLive.Show, :show
      live "/company/edit", CompaniesLive.Edit, :edit
      live "/company/new", CompaniesLive.New, :new

      live "/business_model_form/:id/new", BusinessModelForm.New, :new

      live "/survey_responses", SurveyResponseLive.Index, :index
      live "/survey_responses/new", SurveyResponseLive.Index, :new
      live "/survey_responses/:id/edit", SurveyResponseLive.Index, :edit

      live "/survey_responses/:id", SurveyResponseLive.Show, :show
      live "/survey_responses/:id/show/edit", SurveyResponseLive.Show, :edit
    end
  end

  scope "/", SurveyEngineWeb do
    pipe_through [:browser, :require_authenticated_user, :locale]

    live_session :require_authenticated_user_settings,
      on_mount: [
        {SurveyEngineWeb.UserAuth, :ensure_authenticated},
        {SurveyEngineWeb.ContextSession, :load_site_configuration},
        {ContextSession, :current_page},
        {ContextSession, :set_locale}
      ] do
      get "/error", PageController, :home
      get "/unauthorized", PageController, :unauthorized
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/admin", SurveyEngineWeb do
    pipe_through [:browser, :require_authenticated_user, :locale]

    live_session :admin_authenticated_user,
      on_mount: [
        {SurveyEngineWeb.UserAuth, :ensure_authenticated},
        {SurveyEngineWeb.ContextSession, :load_site_configuration},
        {ContextSession, :current_page},
        {ContextSession, :set_locale},
        {ContextSession, :validate_route}
      ] do
      live "/companies", AdminCompanyLive.Index, :index
      live "/companies/:id", AdminCompanyLive.Show, :show
      live "/companies/:id/assign_form", AdminCompanyLive.Edit, :assign_form
      live "/companies/:id/assign_manager", AdminCompanyLive.Edit, :assign_manager
      live "/companies/:id/edit", AdminCompanyLive.Edit, :edit
      live "/companies/:company_id/new_affiliate", AffiliateLive.New, :new
      live "/companies/:company_id/affiliate", AffiliateLive.Show, :show
      live "/companies/:company_id/affiliate/:id/edit", AffiliateLive.Edit, :edit
      live "/catalogs/currencies", CurrencyLive.Index, :index
      live "/catalogs/currencies/new", CurrencyLive.Index, :new
      live "/catalogs/currencies/:id/edit", CurrencyLive.Index, :edit
      live "/survey_answers", SurveyReponseLive.Index, :index
      live "/survey_answers/:id/validate", SurveyResponseLive.Validate, :validate
      live "/survey_answers/:id", SurveyReponseLive.Show, :show
      live "/survey_answers/:id/edit_item/:item_id", SurveyReponseLive.Show, :edit_response_item
      live "/catalogs/agency_types", AgencyTypeLive.Index, :index

      live "/catalogs/agency_types/new", AgencyTypeLive.Index, :new
      live "/catalogs/agency_types/:id/edit", AgencyTypeLive.Index, :edit

      live "/catalogs/agency_models", AgencyModelLive.Index, :index
      live "/catalogs/agency_models/new", AgencyModelLive.Index, :new
      live "/catalogs/agency_models/:id/edit", AgencyModelLive.Index, :edit

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

      live "/site_configurations", SiteConfigurationLive.Index, :index
      live "/site_configurations/new", SiteConfigurationLive.New, :new
      live "/site_configurations/:id/edit", SiteConfigurationLive.Edit, :edit

      live "/form_groups", FormGroupLive.Index, :index
      live "/form_groups/new", FormGroupLive.Index, :new
      live "/form_groups/:id/edit", FormGroupLive.Index, :edit

      live "/form_groups/:form_group_id/leads_forms", LeadsFormLive.Index, :index
      live "/form_groups/:form_group_id/leads_forms/new", LeadsFormLive.Index, :new
      live "/form_groups/:form_group_id/leads_forms/:id", LeadsFormLive.Show, :show

      live "/form_groups/:form_group_id/leads_forms/:id/edit", LeadsFormLive.Index, :edit

      live "/form_groups/:form_group_id/leads_forms/:lead_form_id/survey_mapper",
           SurveyMapperLive.Index,
           :index

      live "/form_groups/:form_group_id/leads_forms/:lead_form_id/survey_mapper/new",
           SurveyMapperLive.Index,
           :new

      live "/form_groups/:form_group_id/leads_forms/:lead_form_id/survey_mapper/:id/edit",
           SurveyMapperLive.Index,
           :edit

      live "/:lead_form_id/survey_mapper/:id", SurveyMapperLive.Show, :show
      live "/:lead_form_id/survey_mapper/:id/show/edit", SurveyMapperLive.Show, :edit

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
      live "/content/:behaviour/copy/url", SiteContentLive.Index, :policie_url_modal

      live "/notifications", NotificationLive.Index, :index
      live "/notifications/new", NotificationLive.New, :new
      live "/notifications/:id/edit", NotificationLive.Edit, :edit
      live "/notifications/:id", NotificationLive.Show, :show

      live "/reports/pre_registration", ReportLive.PreRegistration, :pre_registration

      live "/:lead_form_id/survey_mapper", SurveyMapperLive.Index, :index
      live "/:lead_form_id/survey_mapper/new", SurveyMapperLive.Index, :new
      live "/:lead_form_id/survey_mapper/:id/edit", SurveyMapperLive.Index, :edit

      live "/:lead_form_id/survey_mapper/:id", SurveyMapperLive.Show, :show
      live "/:lead_form_id/survey_mapper/:id/show/edit", SurveyMapperLive.Show, :edit

      live "/reports/response", ReportLive.SurveyResponse, :survey_response

      live "/roles", RoleLive.Index, :index
      live "/roles/new", RoleLive.Index, :new
      live "/roles/:id/edit", RoleLive.Index, :edit

      live "/users", UserLive.Index, :index
      live "/users/new", UserLive.New, :new
      live "/users/:id/edit_roles", UserLive.Index, :edit_roles

      # live "/permissions_actions", PermissionActionLive.Index, :index
      # live "/permissions_actions/new", PermissionActionLive.Index, :new
      live "/permissions_actions/set", PermissionActionLive.SetPermission, :set_permission
      live "/permissions_actions/sync", PermissionActionLive.SetPermission, :sync_permission
      # live "/permissions_actions/:id/edit", PermissionActionLive.Index, :edit
    end
  end

  scope "/", SurveyEngineWeb do
    pipe_through [:browser, :locale]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [
        {SurveyEngineWeb.UserAuth, :mount_current_user},
        {SurveyEngineWeb.ContextSession, :load_site_configuration},
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

    live_session :embed,
      on_mount: [
        {ContextSession, :load_site_configuration},
        {ContextSession, :current_page},
        {ContextSession, :set_locale}
      ] do
      live "/users/log_in", UserLoginLive, :new
      live "/users/register/form/:token", EmbedLive.UserRegisterForm, :index
    end
  end
end
