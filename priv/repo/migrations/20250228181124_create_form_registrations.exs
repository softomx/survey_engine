defmodule SurveyEngine.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :date, :string
      add :language, :string
      add :agency_name, :string
      add :rfc, :string
      add :legal_name, :string
      add :country, :string
      add :town, :string
      add :city, :string
      add :agency_type, :string
      add :billing_currency, :string
      add :status, :string, default: "pending"

      timestamps(type: :utc_datetime)
    end
  end
end
