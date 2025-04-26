defmodule SurveyEngineWeb.CoreComponents do
  use PetalComponents
  alias SurveyEngine.TransaleteHelper

  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component
  use Gettext, backend: SurveyEngineWeb.Gettext
  import Phoenix.HTML
  alias Phoenix.LiveView.JS

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={[
        "fixed top-2 right-2 mr-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 text-rose-900 shadow-md ring-rose-500 fill-rose-900"
      ]}
      {@rest}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-6">
        <.icon :if={@kind == :info} name="hero-information-circle-mini" class="h-4 w-4" />
        <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="h-4 w-4" />
        {@title}
      </p>
      <p class="mt-2 text-sm leading-5">{msg}</p>
      <button type="button" class="group absolute top-1 right-1 p-2" aria-label={gettext("close")}>
        <.icon name="hero-x-mark-solid" class="h-5 w-5 opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the data structure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="mt-10 space-y-8 bg-white">
        {render_slot(@inner_block, f)}
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          {render_slot(action, f)}
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-semibold leading-6 text-zinc-800">
      {render_slot(@inner_block)}
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-3 flex gap-3 text-sm leading-6 text-rose-600">
      <.icon name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 text-zinc-800">
          {render_slot(@inner_block)}
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-zinc-600">
          {render_slot(@subtitle)}
        </p>
      </div>
      <div class="flex-none">{render_slot(@actions)}</div>
    </header>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title">{@post.title}</:item>
        <:item title="Views">{@post.views}</:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-zinc-100">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
          <dt class="w-1/4 flex-none text-zinc-500">{item.title}</dt>
          <dd class="text-zinc-700">{render_slot(item)}</dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <.icon name="hero-arrow-left-solid" class="h-3 w-3" />
        {render_slot(@inner_block)}
      </.link>
    </div>
    """
  end

  attr :value, :string, required: true

  def company_state_badge(assigns) do
    ~H"""
    <.badge
      :if={@value == "finished"}
      color="success"
      label={TransaleteHelper.survey_response_state("finished")}
    />
    <.badge
      :if={@value == "assigned"}
      color="success"
      label={TransaleteHelper.survey_response_state("Asignado")}
    />
    <.badge
      :if={@value == "pending"}
      color="warning"
      label={TransaleteHelper.survey_response_state("pending")}
    />
    <.badge
      :if={@value == "rejected"}
      color="danger"
      label={TransaleteHelper.survey_response_state("rejected")}
    />
    <.badge
      :if={@value == "approved"}
      color="danger"
      label={TransaleteHelper.survey_response_state("approved")}
    />
    <.badge
      :if={@value == "created"}
      color="danger"
      label={TransaleteHelper.survey_response_state("created")}
    />
    """
  end

  attr :value, :string, required: true

  def response_review_state_badge(assigns) do
    ~H"""
    <.badge
      :if={@value == "pending"}
      color="warning"
      label={TransaleteHelper.survey_response_review_state("pending")}
    />
    <.badge
      :if={@value == "approved"}
      color="success"
      label={TransaleteHelper.survey_response_review_state("approved")}
    />
    <.badge
      :if={@value == "rejected"}
      color="danger"
      label={TransaleteHelper.survey_response_review_state("rejected")}
    />
    """
  end

  attr :required, :boolean, required: true

  def required_badge(assigns) do
    ~H"""
    <.badge :if={@required} color="danger" label="Requerido" />
    <.badge :if={!@required} color="gray" label="opcional" />
    """
  end

  attr :status, :boolean, required: true

  def active_badge(assigns) do
    ~H"""
    <.badge :if={!@status} color="danger" label="Inactivo" />
    <.badge :if={@status} color="success" label="Activo" />
    """
  end

  def notification_action_badge(assigns) do
    ~H"""
    <.badge :if={@value == "register"} color="danger" label="Nuevo registro" />
    <.badge
      :if={@value == "assign_busines_model"}
      color="success"
      label="Asignacion de logica de negocio"
    />
    <.badge :if={@value == "survey_finished"} color="success" label="Fomulario finalizado" />
    <.badge
      :if={@value == "survey_error"}
      color="success"
      label="Error en la informacion del formulario"
    />
    <.badge :if={@value == "survey_accepted"} color="success" label="Formulario aceptado " />
    """
  end

  def language_badge(assigns) do
    ~H"""
    <.badge :if={@value == "es"} color="success" label="Español" />
    <.badge :if={@value == "en"} color="primary" label="Ingles" />
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      time: 300,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      time: 300,
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(SurveyEngineWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(SurveyEngineWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end

  attr(:meta, Flop.Meta, required: true)
  attr(:fields, :list, required: true)
  attr(:id, :string, default: nil)
  attr(:change_event, :string, default: "update-filter")
  attr(:reset_event, :string, default: "reset-filter")
  attr(:submit_event, :string, default: "submit-filter")
  attr(:target, :string, default: nil)
  attr(:debounce, :integer, default: 250)
  attr(:css, :string, default: nil)

  def filter_form(assigns) do
    ~H"""
    <div class="mt-5 md:col-span-2 md:mt-0 pb-2">
      <.form
        :let={f}
        for={@meta}
        as={:filter}
        id={@id}
        phx-target={@target}
        phx-submit={@submit_event}
      >
        <div class="overflow-hidden shadow sm:rounded-md">
          <div class="overflow-hidden shadow sm:rounded-md">
            <div class="bg-white px-4 py-2">
              <div class={"#{@css} mb-2"}>
                <Flop.Phoenix.filter_fields :let={i} form={f} fields={@fields}>
                  <.field
                    field={i.field}
                    label={i.label}
                    type={i.type}
                    {i.rest}
                    options={i.rest[:options]}
                    phx-debounce={@debounce}
                    placeholder={i.rest[:place_holder]}
                    max={i.rest[:maxDate]}
                    autocomplete="off"
                  />
                </Flop.Phoenix.filter_fields>
              </div>

              <div class="flex justify-end">
                <div class="pr-2">
                  <a href="#" phx-target={@target} phx-click={@reset_event} class="py-3 px-4 text-sm">
                    {gettext("Clean")}
                  </a>
                </div>
                <.button type="submit">{gettext("Search")}</.button>
              </div>
            </div>
          </div>
        </div>
      </.form>
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :description, :string, required: true
  attr :type, :string, values: ["markdown"]

  def description(assigns) do
    ~H"""
    <%= if  @type == "html" do %>
      <div class={["prose", @class]}>
        {Earmark.as_html!(@description) |> raw()}
      </div>
    <% else %>
      <div class={["prose", @class]}>
        {@description}
      </div>
    <% end %>
    """
  end

  attr :survey_response, :map, default: %{}
  slot :actions, doc: "the slot for form actions, such as an action button"

  def card_survey_response(assigns) do
    ~H"""
    <.card
      :for={response <- @survey_response.response_items |> Enum.sort_by(fn i -> i.index end)}
      class="my-2"
      variant="outline"
    >
      <.card_content>
        <div class="flex gap-2">
          <div>
            <.badge color="primary" label={response.index} />
          </div>
          <div class="flex-1">
            <p class="text-1xl font-bold text-gray-500">{response.question}</p>
            <%= case response.type do %>
              <% "fileUpload" -> %>
                <div class="flex gap-2">
                  <.card :for={file <- response.answer["data"]} variant="outline">
                    <.card_content category="" class="p-3">
                      <div>
                        <.icon
                          name="hero-document"
                          class="text-primary-700 dark:text-primary-300 w-16 h-16"
                        />
                        <.badge color="primary" label=".PDF" />
                      </div>
                      <a
                        href={"data:application/octet-stream;base64,#{file["file"]}"}
                        download={"#{response.question}.pdf"}
                        class="pc-button pc-button--primary-inverted pc-button--xs pc-button--radius-md "
                      >
                        Ver Documento
                      </a>
                    </.card_content>
                  </.card>
                </div>
              <% "multipleChoiceMulti" -> %>
                <ul>
                  <%= for answer <- response.answer["data"] do %>
                    <li>{answer}</li>
                  <% end %>
                </ul>
              <% _ -> %>
                <p>{response.answer["data"]}</p>
            <% end %>
          </div>
          <div :if={@actions != []}>
            <p class="mt-2 text-sm leading-6 text-zinc-600">
              {render_slot(@actions, response)}
            </p>
          </div>
        </div>
      </.card_content>
    </.card>
    """
  end

  def markdown_text(nil), do: ""

  def markdown_text(type_description, description) do
    if type_description == "html" do
      Earmark.as_html!(description) |> raw()
    else
      description
    end
  end

  def gettext_with_locale(locale, gettext) do
    Gettext.with_locale(SurveyEngineWeb.Gettext, locale, fn ->
      gettext
    end)
  end

  def get_embed_token_valid_env() do
    token_validity = System.get_env("iframe_token_validity")
    case token_validity do
      nil -> 315_360_000
      "" -> 315_360_000
      _ -> String.to_integer(token_validity)
    end
  end
end
