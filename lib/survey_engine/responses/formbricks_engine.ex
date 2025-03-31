defmodule SurveyEngine.Responses.FormbricksEngine do
  alias SurveyEngine.NotificationManager
  alias SurveyEngine.LeadsForms
  alias SurveyEngine.Responses
  alias SurveyEngine.FormbricksClient
  @base_url "https://form-surveys-formbricks-app.mbf3gu.easypanel.host"
  def process_response(response) do
    case response.event do
      "responseCreated" ->
        do_process_response(response.data, &create_new_response/3)

      "responseUpdated" ->
        do_process_response(response.data, &update_response/3)

      "responseFinished" ->
        with {:ok, response_created} <- do_process_response(response.data, &response_finished/3) do
          NotificationManager.notify_survey_finished(response_created, response.site_config_id)
          {:ok, response}
        end

      _ ->
        {:error, "Unknown event"}
    end
  end

  def get_survey(data) do
    FormbricksClient.get_survey(data["external_id"])
  end

  def build_url_embed_survey(%{
        data: %{response: response, current_user: current_user, form: form, company: company}
      }) do
    query_string =
      prefilling_survey(response)

    "#{@base_url}/s/#{form.external_id}?userId=#{current_user.id}&suId=#{build_unique_id(company, current_user)}&#{query_string}"
  end

  defp build_unique_id(company, user) do
    "#{company.business_model_id}-#{user.id}-3"
  end

  defp do_process_response(data, fun) do
    with {:ok, lead_form} <-
           LeadsForms.get_lead_form_by_external_id("formbricks", data["surveyId"]),
         {:ok, survey_response} <-
           FormbricksClient.get_survey(lead_form.external_id),
         {:ok, survey} <- format_survey(survey_response),
         {:ok, response} <- {:ok, format_response(survey, data["data"])} do
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
    %{
      state: "created",
      date: Timex.today(),
      data: %{response: response},
      external_id: data["id"],
      user_id: data["person"]["userId"],
      lead_form_id: lead_form.id,
      form_group_id: lead_form.form_group_id
    }
    |> Responses.create_survey_response()
  end

  defp update_response(response, lead_form, data) do
    previour_response = Responses.get_survey_response_by_external_id(data["id"])

    case previour_response do
      nil ->
        %{
          state: "created",
          date: Timex.today(),
          data: %{response: response},
          external_id: data["id"],
          user_id: data["person"]["userId"],
          lead_form_id: lead_form.id,
          form_group_id: lead_form.form_group_id
        }
        |> Responses.create_survey_response()

      survey_response ->
        attrs = %{
          state: "updated",
          date: Timex.today(),
          data: %{response: response}
        }

        Responses.update_survey_response(survey_response, attrs)
    end
  end

  defp response_finished(response, lead_form, data) do
    previour_response = Responses.get_survey_response_by_external_id(data["id"])

    case previour_response do
      nil ->
        %{
          state: "finished",
          date: Timex.today(),
          data: %{response: response},
          external_id: data["id"],
          user_id: data["person"]["userId"],
          lead_form_id: lead_form.id,
          form_group_id: lead_form.form_group_id
        }
        |> Responses.create_survey_response()

      survey_response ->
        attrs = %{
          state: "finished",
          date: Timex.today(),
          data: %{response: response}
        }

        Responses.update_survey_response(survey_response, attrs)
    end
  end

  defp format_response(_survey, nil), do: []

  defp format_response(survey, data) do
    data
    |> IO.inspect(label: "ksksks")
    |> Enum.reduce([], fn {question_id, answer}, acc ->
      question = Map.get(survey.questions, question_id) |> IO.inspect()

      case question do
        nil ->
          acc

        _ ->
          acc ++
            [
              %{
                index: question.index,
                question: question.title,
                answer: format_answer(answer, question),
                type: question.type,
                external_id: question.id
              }
            ]
      end
    end)
  end

  defp format_answer(answer, %{type: "fileUpload"} = _question) do
    answer
    |> Enum.map(fn a ->
      {:ok, file} = FormbricksClient.encode_file(a)
      file
    end)
  end

  defp format_answer(answer, _question) do
    answer
  end

  defp prefilling_survey(nil), do: nil

  defp prefilling_survey(response) do
    (response.data["response"] || [])
    |> Enum.reduce(%{}, fn response_item, acc ->
      case response_item["type"] do
        "multipleChoiceMulti" ->
          acc
          |> Map.put(response_item["external_id"], response_item["answer"] |> Enum.join(","))

        "fileUpload" ->
          response_item

          # answer =
          #   if allow_multiple_files do
          #     response_item["answer"]
          #   else
          #     response_item["answer"] |> List.first()
          #   end

          acc
          |> Map.put(response_item["external_id"], response_item["answer"] |> Enum.join(","))

        _ ->
          acc
          |> Map.put(response_item["external_id"], response_item["answer"])
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
