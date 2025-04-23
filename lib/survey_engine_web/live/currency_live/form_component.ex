defmodule SurveyEngineWeb.CurrencyLive.FormComponent do
  use SurveyEngineWeb, :live_component

  alias SurveyEngine.Catalogs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.form
        for={@form}
        id="currency-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.field field={@form[:name]} type="text" label="Name" />
        <.field field={@form[:slug]} type="text" label="Slug" />
        <.field field={@form[:active]} type="checkbox" label="Active" />

        <.button phx-disable-with="Saving...">Save Currency</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{currency: currency} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Catalogs.change_currency(currency))
     end)}
  end

  @impl true
  def handle_event("validate", %{"currency" => currency_params}, socket) do
    changeset = Catalogs.change_currency(socket.assigns.currency, currency_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"currency" => currency_params}, socket) do
    save_currency(socket, socket.assigns.action, currency_params)
  end

  defp save_currency(socket, :edit, currency_params) do
    case Catalogs.update_currency(socket.assigns.currency, currency_params) do
      {:ok, _currency} ->
        {:noreply,
         socket
         |> put_flash(:info, "Currency updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_currency(socket, :new, currency_params) do
    case Catalogs.create_currency(currency_params) do
      {:ok, _currency} ->
        {:noreply,
         socket
         |> put_flash(:info, "Currency created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
