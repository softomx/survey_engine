defmodule SurveyEngine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SurveyEngineWeb.Telemetry,
      SurveyEngine.Repo,
      {DNSCluster, query: Application.get_env(:survey_engine, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SurveyEngine.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SurveyEngine.Finch},
      # Start a worker by calling: SurveyEngine.Worker.start_link(arg)
      # {SurveyEngine.Worker, arg},
      # Start to serve requests, typically the last entry
      SurveyEngineWeb.Endpoint,
      Exq
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SurveyEngine.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SurveyEngineWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
