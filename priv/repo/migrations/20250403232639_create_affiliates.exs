defmodule SurveyEngine.Repo.Migrations.CreateAffiliates do
  use Ecto.Migration

  def change do
    create table(:affiliates) do
      add :name, :string
      add :affiliate_slug, :string
      add :trading_name, :string
      add :business_name, :string
      add :rfc, :string
      add :company_type, :string

      timestamps(type: :utc_datetime)
    end
  end
end
