defmodule SurveyEngine.Notifications.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field :action, :string

    embeds_many :to, SurveyEngine.Notifications.NotificationTo

    has_many :contents, SurveyEngine.Translations.Translation,
      foreign_key: :resource_id,
      where: [type: "notifications", behaviour: "content"]

    has_many :subjects, SurveyEngine.Translations.Translation,
      foreign_key: :resource_id,
      where: [type: "notifications", behaviour: "subject"]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:action])
    |> validate_required([:action])
    |> cast_embed(:to)
  end
end
