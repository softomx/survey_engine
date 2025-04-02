defmodule SurveyEngine.Repo.Migrations.AddApiTokenSiteConfig do
  use Ecto.Migration

  def change do
    alter table(:site_configurations) do
      add :consumer_api_token, :string
    end
  end
end
