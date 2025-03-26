defmodule SurveyEngine.Repo.Migrations.AddFormGroupLeadForms do
  use Ecto.Migration

  def change do
    alter table(:leads_forms) do
      add :form_group_id, references(:form_groups, on_delete: :delete_all)
    end
  end
end
