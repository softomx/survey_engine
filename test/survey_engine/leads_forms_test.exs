defmodule SurveyEngine.LeadsFormsTest do
  use SurveyEngine.DataCase

  alias SurveyEngine.LeadsForms

  describe "leads_forms" do
    alias SurveyEngine.LeadsForms.LeadsForm

    import SurveyEngine.LeadsFormsFixtures

    @invalid_attrs %{active: nil, name: nil, language: nil, external_id: nil}

    test "list_leads_forms/0 returns all leads_forms" do
      leads_form = leads_form_fixture()
      assert LeadsForms.list_leads_forms() == [leads_form]
    end

    test "get_leads_form!/1 returns the leads_form with given id" do
      leads_form = leads_form_fixture()
      assert LeadsForms.get_leads_form!(leads_form.id) == leads_form
    end

    test "create_leads_form/1 with valid data creates a leads_form" do
      valid_attrs = %{active: true, name: "some name", language: "some language", external_id: "some external_id"}

      assert {:ok, %LeadsForm{} = leads_form} = LeadsForms.create_leads_form(valid_attrs)
      assert leads_form.active == true
      assert leads_form.name == "some name"
      assert leads_form.language == "some language"
      assert leads_form.external_id == "some external_id"
    end

    test "create_leads_form/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LeadsForms.create_leads_form(@invalid_attrs)
    end

    test "update_leads_form/2 with valid data updates the leads_form" do
      leads_form = leads_form_fixture()
      update_attrs = %{active: false, name: "some updated name", language: "some updated language", external_id: "some updated external_id"}

      assert {:ok, %LeadsForm{} = leads_form} = LeadsForms.update_leads_form(leads_form, update_attrs)
      assert leads_form.active == false
      assert leads_form.name == "some updated name"
      assert leads_form.language == "some updated language"
      assert leads_form.external_id == "some updated external_id"
    end

    test "update_leads_form/2 with invalid data returns error changeset" do
      leads_form = leads_form_fixture()
      assert {:error, %Ecto.Changeset{}} = LeadsForms.update_leads_form(leads_form, @invalid_attrs)
      assert leads_form == LeadsForms.get_leads_form!(leads_form.id)
    end

    test "delete_leads_form/1 deletes the leads_form" do
      leads_form = leads_form_fixture()
      assert {:ok, %LeadsForm{}} = LeadsForms.delete_leads_form(leads_form)
      assert_raise Ecto.NoResultsError, fn -> LeadsForms.get_leads_form!(leads_form.id) end
    end

    test "change_leads_form/1 returns a leads_form changeset" do
      leads_form = leads_form_fixture()
      assert %Ecto.Changeset{} = LeadsForms.change_leads_form(leads_form)
    end
  end

  describe "form_groups" do
    alias SurveyEngine.LeadsForms.FormGroup

    import SurveyEngine.LeadsFormsFixtures

    @invalid_attrs %{name: nil}

    test "list_form_groups/0 returns all form_groups" do
      form_group = form_group_fixture()
      assert LeadsForms.list_form_groups() == [form_group]
    end

    test "get_form_group!/1 returns the form_group with given id" do
      form_group = form_group_fixture()
      assert LeadsForms.get_form_group!(form_group.id) == form_group
    end

    test "create_form_group/1 with valid data creates a form_group" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %FormGroup{} = form_group} = LeadsForms.create_form_group(valid_attrs)
      assert form_group.name == "some name"
    end

    test "create_form_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LeadsForms.create_form_group(@invalid_attrs)
    end

    test "update_form_group/2 with valid data updates the form_group" do
      form_group = form_group_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %FormGroup{} = form_group} = LeadsForms.update_form_group(form_group, update_attrs)
      assert form_group.name == "some updated name"
    end

    test "update_form_group/2 with invalid data returns error changeset" do
      form_group = form_group_fixture()
      assert {:error, %Ecto.Changeset{}} = LeadsForms.update_form_group(form_group, @invalid_attrs)
      assert form_group == LeadsForms.get_form_group!(form_group.id)
    end

    test "delete_form_group/1 deletes the form_group" do
      form_group = form_group_fixture()
      assert {:ok, %FormGroup{}} = LeadsForms.delete_form_group(form_group)
      assert_raise Ecto.NoResultsError, fn -> LeadsForms.get_form_group!(form_group.id) end
    end

    test "change_form_group/1 returns a form_group changeset" do
      form_group = form_group_fixture()
      assert %Ecto.Changeset{} = LeadsForms.change_form_group(form_group)
    end
  end
end
