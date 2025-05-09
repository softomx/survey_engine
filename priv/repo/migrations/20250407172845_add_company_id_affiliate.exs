defmodule SurveyEngine.Repo.Migrations.AddCompanyIdAffiliate do
  use Ecto.Migration

  def change do
    alter table(:affiliates) do
      add :company_id, references(:companies, on_delete: :delete_all)
    end
  end
end
