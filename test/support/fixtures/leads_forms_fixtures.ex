defmodule SurveyEngine.LeadsFormsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SurveyEngine.LeadsForms` context.
  """

  @doc """
  Generate a leads_form.
  """
  def leads_form_fixture(attrs \\ %{}) do
    {:ok, leads_form} =
      attrs
      |> Enum.into(%{
        active: true,
        external_id: "some external_id",
        language: "some language",
        name: "some name"
      })
      |> SurveyEngine.LeadsForms.create_leads_form()

    leads_form
  end

  @doc """
  Generate a form_group.
  """
  def form_group_fixture(attrs \\ %{}) do
    {:ok, form_group} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> SurveyEngine.LeadsForms.create_form_group()

    form_group
  end
end
