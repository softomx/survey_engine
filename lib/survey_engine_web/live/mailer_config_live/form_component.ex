defmodule SurveyEngineWeb.MailerConfigLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Mailer.MailerManager

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.form
        for={@form}
        id="mailer_config-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input type="hidden" field={@form[:site_configuration_id]} value={@site_config_id} />
        <.field field={@form[:name]} type="text" label="Name" />
        <.field field={@form[:email_from]} type="text" label="Remitente" />
        <.field field={@form[:email_name]} type="text" label="Nombre remitente" />
        <.combo_box
          field={@form[:adapter]}
          type="select"
          label="proveedor"
          placeholder="selecciona un proveedor"
          options={[
            {"AWS", "amazon_ses"},
            {"Mailgun", "mailgun"},
            {"Sparkpost", "sparkpost"},
            {"Mailjet", "mailjet"}
          ]}
        />
        <.inputs_for :let={f2} field={@form[:configuration]}>
          <.input
            type="hidden"
            field={f2[:adapter]}
            value={Phoenix.HTML.Form.input_value(@form, :adapter)}
          />
          <.field
            :if={show_input(Phoenix.HTML.Form.input_value(@form, :adapter), :api_key)}
            field={f2[:api_key]}
            type="text"
            label="Apikey"
          />
          <.field
            :if={show_input(Phoenix.HTML.Form.input_value(@form, :adapter), :secret)}
            field={f2[:secret]}
            type="text"
            label="secret"
          />
          <.field
            :if={show_input(Phoenix.HTML.Form.input_value(@form, :adapter), :access_key)}
            field={f2[:access_key]}
            type="text"
            label="access key"
          />
          <.field
            :if={show_input(Phoenix.HTML.Form.input_value(@form, :adapter), :region)}
            field={f2[:region]}
            type="text"
            label="Region"
          />
          <.field
            :if={show_input(Phoenix.HTML.Form.input_value(@form, :adapter), :domain)}
            field={f2[:domain]}
            type="text"
            label="Region"
          />
        </.inputs_for>

        <.button phx-disable-with="Saving...">Save Site configuration</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{mailer_config: mailer_config} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(MailerManager.change_mailer_config(mailer_config))
     end)}
  end

  @impl true
  def handle_event("validate", %{"mailer_configuration" => mailer_config_params}, socket) do
    changeset =
      MailerManager.change_mailer_config(
        socket.assigns.mailer_config,
        mailer_config_params
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"mailer_configuration" => mailer_config_params}, socket) do
    save_mailer_config(socket, socket.assigns.action, mailer_config_params)
  end

  defp save_mailer_config(socket, :edit, mailer_config_params) do
    case MailerManager.update_mailer_config(
           socket.assigns.mailer_config,
           mailer_config_params
         ) do
      {:ok, _mailer_config} ->
        {:noreply,
         socket
         |> put_flash(:info, "Site configuration updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_mailer_config(socket, :new, mailer_config_params) do
    case MailerManager.create_mailer_config(mailer_config_params) |> IO.inspect() do
      {:ok, mailer_config} ->
        {:noreply,
         socket
         |> put_flash(:info, "Site configuration created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp show_input(current_adapter, field) do
    cond do
      field in [:secret, :access_key, :region] and current_adapter == "amazon_ses" ->
        true

      field in [:api_key] and current_adapter == "sparkpost" ->
        true

      field in [:api_key, :secret] and current_adapter == "mailjet" ->
        true

      field in [:api_key, :domain] and current_adapter == "mailgun" ->
        true

      true ->
        false
    end
  end
end
