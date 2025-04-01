defmodule SurveyEngineWeb.BusinessConfigLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.BusinessModels

  @impl true
  def update(%{business_config: business_config} = assigns, socket) do
    changeset = BusinessModels.change_business_config(business_config)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(:depend_lead_forms, assigns.form_groups)}
  end

  @impl true
  def handle_event("validate", %{"business_config" => business_config_params}, socket) do
    changeset =
      socket.assigns.business_config
      |> BusinessModels.change_business_config(business_config_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset) |> assign_depend_lead_forms(business_config_params)}
  end

  def handle_event("save", %{"business_config" => business_config_params}, socket) do
    save_business_config(socket, socket.assigns.action, business_config_params)
  end

  defp save_business_config(socket, :edit, business_config_params) do
    case BusinessModels.update_business_config(
           socket.assigns.business_config,
           business_config_params
         ) do
      {:ok, _business_config} ->
        {:noreply,
         socket
         |> put_flash(:info, "Actualizado correctamente")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_business_config(socket, :new, business_config_params) do
    case BusinessModels.create_business_config(business_config_params) do
      {:ok, _business_config} ->
        {:noreply,
         socket
         |> put_flash(:info, "Creado correctamente")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp assign_depend_lead_forms(socket, business_config_params) do
    assign(
      socket,
      :depend_lead_forms,
      socket.assigns.form_groups
      |> Enum.reject(fn {_k, v} -> "#{v}" == business_config_params["form_group_id"] end)
    )
  end
end
