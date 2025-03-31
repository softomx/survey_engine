defmodule SurveyEngine.Repo.Migrations.RemoveUnusedFields do
  use Ecto.Migration

  def change do
    alter table(:leads_forms) do
      remove :name
    end

    alter table(:companies) do
      remove :rfc
      remove :date
    end

    alter table(:business_models) do
      remove :slug
    end

    alter table(:notifications) do
      remove :from
      remove :from_name
      remove :subject
      remove :content
    end
  end
end
