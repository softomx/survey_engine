defmodule SurveyEngine.Responses.FormbricksEngine do
  alias SurveyEngine.SiteConfigurations
  alias SurveyEngine.Companies
  alias SurveyEngine.Accounts
  alias SurveyEngine.NotificationManager
  alias SurveyEngine.LeadsForms
  alias SurveyEngine.Responses
  alias SurveyEngine.FormbricksClient

  def process_response(response) do
    case response.event do
      "responseCreated" ->
        do_process_response(response.site_config_id, response.data, &create_new_response/3)

      "responseUpdated" ->
        do_process_response(response.site_config_id, response.data, &update_response/3)

      "responseFinished" ->
        with {:ok, response_created} <-
               do_process_response(response.site_config_id, response.data, &response_finished/3),
             {:ok, user} <- Accounts.get_user(response_created.user_id),
             {:ok, company} <- Companies.get_company(user.company_id),
             {:ok, _company} <- Companies.update_company(company, %{state: "finished"}) do
          NotificationManager.notify_survey_finished(response_created, response.site_config_id)
          {:ok, response}
        end

      _ ->
        {:error, "Unknown event"}
    end
  end

  def get_survey(params) do
    with {:ok, site_config} <- SiteConfigurations.get_site_configuration(params.site_config_id),
         {:ok, survey_provider} <- get_surver_provider_config(site_config),
         {:ok, survey_response} <-
           FormbricksClient.get_survey(survey_provider, params.data.id),
         {:ok, survey} <- format_survey(survey_response) do
      {:ok, survey}
    end
  end

  def build_url_embed_survey(%{
        site_config_id: site_config,
        data: %{
          response: response,
          current_user: current_user,
          form: form,
          company: company
        }
      }) do
    with {:ok, site_config} <- SiteConfigurations.get_site_configuration(site_config.id),
         {:ok, query_string} <- {:ok, prefilling_survey(response)},
         {:ok, survey_provider} <- get_surver_provider_config(site_config) do
      "#{survey_provider.url}/s/#{form.external_id}?skipPrefilled=true&userId=#{current_user.id}&suId=#{build_unique_id(company, current_user)}&#{query_string}"
    end
  end

  def get_surver_provider_config(site_config) do
    site_config.survey_providers
    |> Enum.find(fn provider -> provider.provider == "formbricks" end)
    |> case do
      nil -> {:error, "Provider not found"}
      provider -> {:ok, provider}
    end
  end

  defp build_unique_id(company, user) do
    "#{company.business_model_id}-#{user.id}-#{company.id}"
  end

  defp do_process_response(site_config_id, data, fun) do
    with {:ok, site_config} <- SiteConfigurations.get_site_configuration(site_config_id),
         {:ok, lead_form} <-
           LeadsForms.get_lead_form_by_external_id("formbricks", data["surveyId"]),
         {:ok, survey_provider_config} <- get_surver_provider_config(site_config),
         {:ok, survey_response} <-
           FormbricksClient.get_survey(survey_provider_config, lead_form.external_id),
         {:ok, survey} <- format_survey(survey_response),
         {:ok, response} <-
           {:ok, format_client_response(survey, data["data"], survey_provider_config)} do
      fun.(response, lead_form, data)
    end
  end

  defp format_survey(data) do
    questions =
      data["data"]["questions"]
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {q, index}, acc ->
        question = %{
          required: q["required"],
          type: q["type"],
          title: q["headline"]["default"],
          options: q["choices"] || [],
          id: q["id"],
          index: index,
          allow_multiple_files: q["allowMultipleFiles"] || false
        }

        acc
        |> Map.put(q["id"], question)
      end)

    {:ok, %{questions: questions, name: data["name"], status: data["status"]}}
  end

  defp create_new_response(response, lead_form, data) do
    previour_response =
      Responses.get_survey_response_by_external_id(data["person"]["userId"], lead_form.id)

    case previour_response do
      nil ->
        do_create_new_response(
          response,
          lead_form,
          data,
          "created"
        )

      survey_response ->
        update_response_multi(survey_response, response, "created")
    end
  end

  defp do_create_new_response(response, lead_form, data, state) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:survey_response, fn _, _ ->
      %{
        state: state,
        date: Timex.today(),
        external_id: data["id"],
        user_id: data["person"]["userId"],
        lead_form_id: lead_form.id,
        form_group_id: lead_form.form_group_id
      }
      |> Responses.create_survey_response()
    end)
    |> Ecto.Multi.merge(fn %{survey_response: survey_response} ->
      response
      |> Enum.reduce(Ecto.Multi.new(), fn response, multi ->
        multi
        |> Ecto.Multi.run("item#{response.index}", fn _, _ ->
          response
          |> Map.put(:survey_response_id, survey_response.id)
          |> Responses.create_survey_response_item()
        end)
      end)
    end)
    |> SurveyEngine.Repo.transaction()
    |> case do
      {:ok, %{survey_response: survey_response}} ->
        {:ok, survey_response}

      {:error, _multi, changeset, _} ->
        {:error, changeset}
    end
  end

  defp update_response(response, lead_form, data) do
    previour_response =
      Responses.get_survey_response_by_external_id(data["person"]["userId"], lead_form.id)

    case previour_response do
      nil ->
        do_create_new_response(
          response,
          lead_form,
          data,
          "updated"
        )

      survey_response ->
        update_response_multi(survey_response, response, "updated")
    end
  end

  defp response_finished(response, lead_form, data) do
    previour_response =
      Responses.get_survey_response_by_external_id(data["person"]["userId"], lead_form.id)

    case previour_response do
      nil ->
        do_create_new_response(
          response,
          lead_form,
          data,
          "finished"
        )

      survey_response ->
        update_response_multi(survey_response, response, "finished")
    end
  end

  defp update_response_multi(survey_response, current_response, new_state) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:survey_response, fn _, _ ->
      Responses.update_survey_response(survey_response, %{
        state: new_state
      })
    end)
    |> Ecto.Multi.merge(fn %{survey_response: survey_response} ->
      current_response
      |> Enum.reduce(Ecto.Multi.new(), fn response, multi ->
        multi
        |> Ecto.Multi.run("item#{response.index}", fn _, _ ->
          prev_item =
            survey_response.response_items
            |> Enum.find(&(&1.question_id == response.question_id))

          if prev_item do
            Responses.update_survey_response_item(prev_item, response)
          else
            response
            |> Map.put(:survey_response_id, survey_response.id)
            |> Responses.create_survey_response_item()
          end
        end)
      end)
    end)
    |> SurveyEngine.Repo.transaction()
    |> case do
      {:ok, %{survey_response: survey_response}} ->
        {:ok, survey_response}

      {:error, _multi, changeset, _} ->
        {:error, changeset}
    end
  end

  defp format_client_response(_survey, nil, _survey_provider_config), do: []

  defp format_client_response(survey, data, survey_provider_config) do
    data
    |> Enum.reduce([], fn {question_id, answer}, acc ->
      question = Map.get(survey.questions, question_id)

      case question do
        nil ->
          acc

        _ ->
          acc ++
            [
              %{
                index: question.index,
                question: question.title,
                answer: format_answer(answer, question, survey_provider_config),
                type: question.type,
                question_id: question.id
              }
            ]
      end
    end)
  end

  defp format_answer(answer, %{type: "fileUpload"} = _question, survey_provider_config) do
    answer =
      answer
      |> Enum.map(fn url ->
        {:ok, file} = FormbricksClient.encode_file(url, survey_provider_config)
        %{url: url, file: file}
      end)

    %{data: answer}
  end

  defp format_answer(answer, _question, _survey_provider_config) do
    %{data: answer}
  end

  defp prefilling_survey(nil), do: nil

  defp prefilling_survey(response) do
    (response.response_items || [])
    |> Enum.reduce(%{}, fn response_item, acc ->
      case response_item.type do
        "multipleChoiceMulti" ->
          acc
          |> Map.put(response_item.question_id, response_item.answer["data"] |> Enum.join(","))

        "fileUpload" ->
          acc
          |> Map.put(
            response_item.question_id,
            response_item.answer["data"] |> Enum.map(& &1["url"]) |> Enum.join(",")
          )

        _ ->
          acc
          |> Map.put(response_item.question_id, response_item.answer["data"])
      end
    end)
    |> URI.encode_query()
  end

  def encode_file(file_url) do
    case HTTPoison.get(file_url, []) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Base.encode64(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error, "Unauthorized"}

      {:ok, %HTTPoison.Response{status_code: 500}} ->
        {:error, "Internal server error"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
