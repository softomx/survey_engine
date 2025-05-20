defmodule SurveyEngine.Translations.Translation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "translations" do
    field :type, :string
    field :description, :string
    field :resource_id, :id
    field :language, :string
    field :behaviour, :string
    field :content_type, :string, default: "text_plain"
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(translation, attrs) do
    translation
    |> cast(attrs, [:type, :description, :resource_id, :language, :behaviour, :content_type])
    |> validate_required([:type, :description, :language, :behaviour, :content_type])
    |> unique_constraint(:language, name: :translations_resource_id_behaviour_type_language_index)
  end
end
