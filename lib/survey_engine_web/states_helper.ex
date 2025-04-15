defmodule SurveyEngine.TransaleteHelper do
  use Gettext, backend: SurveyEngineWeb.Gettext

  def survey_response_state(state) do
    case state do
      "finished" -> gettext("survey_response.finished")
      "updated" -> gettext("survey_response.updated")
      "pending" -> gettext("survey_response.pending")
      "rejected" -> gettext("survey_response.rejected")
      "approved" -> gettext("survey_response.approved")
      "init" -> gettext("survey_response.init")
      _ -> state
    end
  end

  def survey_response_review_state(state) do
    case state do
      "pending" -> gettext("survey_response_review.pending")
      "approved" -> gettext("survey_response_review.approved")
      "rejected" -> gettext("survey_response_review.rejected")
      _ -> state
    end
  end

  def list_survey_response_states() do
    ["pending", "updated", "finished", "rejected", "approved"]
    |> Enum.map(fn state ->
      {survey_response_state(state), state}
    end)
  end

  def list_languages() do
    [{language("es"), "es"}, {language("en"), "en"}]
  end

  def language(language) do
    case language do
      "es" ->
        "Español"

      "en" ->
        "Ingles"
    end
  end

  def permission_resource(resource) do
    case resource do
      "AdminCompanyLive" -> gettext("permissions.admin_company")
      "AffiliateLive" -> gettext("permissions.affiliate")
      "AgencyTypeLive" -> gettext("permissions.agency_types")
      "BusinessConfigLive" -> gettext("permissions.business_config")
      "BusinessModelForm" -> gettext("permissions.business_model")
      "BusinessModelLive" -> gettext("permissions.business_model")
      "CompanyLive" -> gettext("permissions.company")
      "CurrencyLive" -> gettext("permissions.currency")
      "FormGroupLive" -> gettext("permissions.form_group")
      "LeadsFormLive" -> gettext("permissions.leads_form")
      "MailerConfigLive" -> gettext("permissions.mailer_config")
      "NotificationLive" -> gettext("permissions.notification")
      "PermissionActionLive" -> gettext("permissions.permission_config")
      "PersonalTitleLive" -> gettext("permissions.personal_title")
      "ReportLive" -> gettext("permissions.report")
      "RoleLive" -> gettext("permissions.role")
      "TranslationLive" -> gettext("permissions.translations")
      "SurveyResponseLive" -> gettext("permissions.survey_response")
      "SurveyMapperLive" -> gettext("permissions.survey_mapper")
      "SiteConfigurationLive" -> gettext("permissions.site_configuration")
      _ -> resource
    end
  end

  def permission_action(action) do
    case action do
      "new" -> gettext("permissions.new")
      "edit" -> gettext("permissions.edit")
      "index" -> gettext("permissions.index")
      "show" -> gettext("permissions.show")
      "assign" -> gettext("permissions.assign")
      "new_affiliate" -> gettext("permissions.new_affiliate")
      "show_affiliate" -> gettext("permissions.show_affiliate")
      "sync_permission" -> gettext("permissions.sync_permission")
      "set_permission" -> gettext("permissions.set_permission")
      "pre_registration" -> gettext("permissions.report_pre_registration")
      "survey_response" -> gettext("permissions.report_survey_response")
      _ -> action
    end
  end

end
