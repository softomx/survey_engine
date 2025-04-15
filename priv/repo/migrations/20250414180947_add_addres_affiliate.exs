defmodule SurveyEngine.Repo.Migrations.AddAddresAffiliate do
  use Ecto.Migration

  def change do
    alter table(:affiliates) do
      add :address, :map
      add :agency_type, :string
      add :base_currency, :string
      add :external_affiliate_id, :string
      add :state, :string, default: "draft"
    end

    alter table(:companies) do
      add :agency_model, :string
    end
  end
end
