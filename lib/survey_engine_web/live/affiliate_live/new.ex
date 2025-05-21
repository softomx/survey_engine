defmodule SurveyEngineWeb.AffiliateLive.New do
  use SurveyEngineWeb, :live_view
  alias SurveyEngine.Catalogs
  alias SurveyEngine.AffiliateEngine.Address

  alias SurveyEngine.SurveyMappers
  alias SurveyEngine.{Companies, Responses}
  alias SurveyEngine.AffiliateEngine.Affiliate
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, %{"company_id" => id}) do
    company = Companies.get_company!(id)

    responses =
      Responses.list_survey_resposes(%{
        filter: %{
          state: "finished",
          review_state: "approved",
          company_id: company.id
        }
      })
      |> Responses.survey_resposes_with_preloads([:response_items, :user, :form_group])

    if length(responses) == 0 do
      socket
      |> put_flash(:error, "No hay respuestas disponibles para la empresa #{company.legal_name}")
      |> push_navigate(to: ~p"/admin/companies")
    else
      socket
      |> assign(:page_title, "#{String.upcase(company.legal_name)}")
      |> assign(:company, company)
      |> assign(:responses, responses)
      |> assign(
        :currencies,
        Catalogs.list_currencies() |> Enum.map(&{&1.name, String.downcase(&1.name)})
      )
      |> assign_affiliate(nil)
    end
  end

  @impl true
  def handle_event("select_response", %{"survey_response_id" => survey_response_id}, socket) do
    {:noreply, socket |> assign_affiliate(survey_response_id)}
  end

  defp assign_affiliate(socket, survey_response_id) do
    responses =
      socket.assigns.responses

    affiliate =
      cond do
        is_nil(survey_response_id) and length(responses) == 1 ->
          responses
          |> List.first()
          |> mapper_affiliate(socket.assigns.company)

        true ->
          responses
          |> Enum.find(fn response -> "#{response.id}" == "#{survey_response_id}" end)
          |> case do
            nil -> %Affiliate{company_id: socket.assigns.company.id}
            response -> mapper_affiliate(response, socket.assigns.company)
          end
      end

    socket
    |> assign(:affiliate, affiliate)
  end

  defp mapper_affiliate(response, company) do
    init_affiliate =
      %Affiliate{
        company_id: company.id,
        trading_name: company.legal_name,
        business_name: company.agency_name,
        name: company.legal_name,
        agency_type: company.agency_type,
        agency_model: company.agency_model,
        base_currency: company.billing_currency,
        address: %Address{
          country: company.country,
          state: company.town,
          city: company.city
        }
      }

    mappers =
      SurveyMappers.list_survey_mappers(%{
        filter: %{survey_id: response.lead_form_id, type: "affiliate"}
      })

    if length(mappers) > 0 do
      res = response.response_items

      Enum.reduce(mappers, init_affiliate, fn mapper, acc ->
        Enum.find(res, fn r -> r.question_id == "#{mapper.question_id}" end)
        |> case do
          nil -> acc
          res_value -> Map.put(acc, String.to_atom(mapper.field), res_value.answer["data"])
        end
      end)
    else
      init_affiliate
    end
  end
end
