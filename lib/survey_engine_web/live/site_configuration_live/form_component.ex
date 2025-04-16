defmodule SurveyEngineWeb.SiteConfigurationLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.SiteConfigurations

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
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
        <.field field={@form[:active]} type="checkbox" label="Active" />

        <.label>Webhook</.label>
        <.inputs_for :let={extra_config} field={@form[:extra_config]}>
          <.field field={extra_config[:url]} type="text" label="url" />
          <.field field={extra_config[:api_key]} type="text" label="API key" />
        </.inputs_for>
        <.label>Configuracion de proveedores de formularios</.label>
        <input type="hidden" name="notitication[providers_drop][]" />
        <.inputs_for :let={survey_provider_form} field={@form[:survey_providers]}>
          <div class="flex items-center gap-2">
            <input
              type="hidden"
              name="site_configuration[to_sort][]"
              value={survey_provider_form.index}
            />
            <.combo_box
              options={[{"Formbricks", "formbricks"}]}
              type="select"
              field={survey_provider_form[:provider]}
              label="Proveedor"
            />
            <.field type="text" wrapper_class="flex-1" field={survey_provider_form[:url]} label="Url" />
            <.field type="text" field={survey_provider_form[:api_key]} label="apiKey" />

            <.button
              with_icon
              color="danger"
              type="button"
              size="xs"
              name="site_configuration[providers_drop][]"
              value={survey_provider_form.index}
              phx-click={JS.dispatch("change")}
            >
              <.icon name="hero-x-mark" class="w-4 h-4 " />
            </.button>
          </div>
        </.inputs_for>
        <.button
          with_icon
          color="info"
          type="button"
          size="xs"
          name="site_configuration[providers_sort][]"
          value="new"
          phx-click={JS.dispatch("change")}
        >
          <.icon name="hero-plus" class="w-4 h-4" /> proveedor formularios
        </.button>

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
         |> push_navigate(to: socket.assigns.patch)}

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
