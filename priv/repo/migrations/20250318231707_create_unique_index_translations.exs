defmodule SurveyEngine.Repo.Migrations.CreateUniqueIndexTranslations do
  use Ecto.Migration

  def change do
    create unique_index(:translations, [:resource_id, :behaviour, :type, :language])
  end
end
