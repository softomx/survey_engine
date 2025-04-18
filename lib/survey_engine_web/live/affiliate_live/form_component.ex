defmodule SurveyEngineWeb.AffiliateLive.FormComponent do
  alias SurveyEngine.NotificationManager
  alias SurveyEngine.Catalogs
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.AffiliateEngine

  @impl true
  def update(%{affiliate: affiliate} = assigns, socket) do
    changeset = AffiliateEngine.change_affiliate(affiliate)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(:states, [])
     |> assign(:countries, Countries.all() |> Enum.map(&{&1.name, &1.alpha2}))
     |> assign(:company_types, Catalogs.list_agency_types() |> Enum.map(& &1.name))
     |> assign(:agency_models, Catalogs.list_agency_models() |> Enum.map(& &1.name))
     |> assign(:states, get_states(affiliate.address))}
  end

  @impl true
  def handle_event("validate", %{"affiliate" => affiliate_params}, socket) do
    changeset =
      socket.assigns.affiliate
      |> AffiliateEngine.change_affiliate(affiliate_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"affiliate" => affiliate_params}, socket) do
    save_affiliate(socket, socket.assigns.action, affiliate_params)
  end

  defp save_affiliate(socket, :edit, affiliate_params) do
    case AffiliateEngine.update_affiliate(socket.assigns.affiliate, affiliate_params) do
      {:ok, _affiliate} ->
        {:noreply,
         socket
         |> put_flash(:info, "Affiliate updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_affiliate(socket, :new, affiliate_params) do
    affiliate_params = Map.put(affiliate_params, "created_by_id", socket.assigns.current_user.id)

    case AffiliateEngine.create_affiliate(affiliate_params) do
      {:ok, affiliate} ->
        NotificationManager.notify_created_affiliate(
          socket.assigns.current_user,
          socket.assigns.site_config,
          affiliate.company_id
        )

        {:noreply,
         socket
         |> put_flash(:info, "Affiliate created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp get_states(nil), do: []

  defp get_states(%{country: country}) do
    country =
      Countries.filter_by(:alpha2, country)
      |> List.first()

    country
    |> Countries.Subdivisions.all()
    |> Enum.map(&{&1.name, &1.name})
  end
end
