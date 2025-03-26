defmodule SurveyEngineWeb.SiteConfigurationLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.SiteConfigurations

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage site_configuration records in your database.</:subtitle>
      </.header>

      <.form
        for={@form}
        id="site_configuration-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.field field={@form[:name]} type="text" label="Name" />
        <.field field={@form[:url]} type="text" label="Url" />
        <.field field={@form[:tenant]} type="text" label="Tenant" />
        <.field field={@form[:active]} type="checkbox" label="Active" />

        <.button phx-disable-with="Saving...">Save Site configuration</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{site_configuration: site_configuration} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(SiteConfigurations.change_site_configuration(site_configuration))
     end)}
  end

  @impl true
  def handle_event("validate", %{"site_configuration" => site_configuration_params}, socket) do
    changeset =
      SiteConfigurations.change_site_configuration(
        socket.assigns.site_configuration,
        site_configuration_params
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"site_configuration" => site_configuration_params}, socket) do
    save_site_configuration(socket, socket.assigns.action, site_configuration_params)
  end

  defp save_site_configuration(socket, :edit, site_configuration_params) do
    case SiteConfigurations.update_site_configuration(
           socket.assigns.site_configuration,
           site_configuration_params
         ) do
      {:ok, _site_configuration} ->
        {:noreply,
         socket
         |> put_flash(:info, "Site configuration updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_site_configuration(socket, :new, site_configuration_params) do
    case SiteConfigurations.create_site_configuration(site_configuration_params) do
      {:ok, site_configuration} ->
        {:noreply,
         socket
         |> put_flash(:info, "Site configuration created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
