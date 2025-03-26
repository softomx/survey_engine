defmodule SurveyEngine.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :action, :string
      add :to, {:array, :map}
      add :from, :string
      add :from_name, :string
      add :subject, :string
      add :content, :text

      timestamps(type: :utc_datetime)
    end
  end
end
