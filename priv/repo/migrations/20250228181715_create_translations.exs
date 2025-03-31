defmodule SurveyEngine.Repo.Migrations.CreateTranslations do
  use Ecto.Migration

  def change do
    create table(:translations) do
      add :type, :string
      add :description, :text
      add :resource_id, :id
      add :language, :string
      add :content_type, :string
      add :behaviour, :string
      timestamps(type: :utc_datetime)
    end
  end
end
