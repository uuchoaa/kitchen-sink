# frozen_string_literal: true

require "test_helper"

class Components::ModelFormTest < ActiveSupport::TestCase
  setup do
    @agency = Agency.create!(name: "Test Agency")
    @recruter = Recruter.create!(name: "Test Recruter", agency: @agency)
    @deal = Deal.new(description: "Test Deal", stage: "open", agency: @agency, recruter: @recruter)
  end

  test "generates namespaced field names" do
    form = Components::ModelForm.new(model: @deal, action: "/deals")

    assert_equal "deal[description]", form.field_name(:description)
    assert_equal "deal[stage]", form.field_name(:stage)
  end

  test "generates namespaced field IDs" do
    form = Components::ModelForm.new(model: @deal, action: "/deals")

    assert_equal "deal_description", form.field_id(:description)
    assert_equal "deal_stage", form.field_id(:stage)
  end

  test "returns model attribute values" do
    form = Components::ModelForm.new(model: @deal, action: "/deals")

    assert_equal "Test Deal", form.field_value(:description, nil)
    assert_equal "open", form.field_value(:stage, nil)
  end

  test "explicit values override model values" do
    form = Components::ModelForm.new(model: @deal, action: "/deals")

    assert_equal "Override", form.field_value(:description, "Override")
  end

  test "returns field errors from model" do
    @deal.description = nil
    @deal.valid? # trigger validations

    form = Components::ModelForm.new(model: @deal, action: "/deals")

    error = form.field_error(:description)
    assert_not_nil error
    assert error.is_a?(String)
  end

  test "returns nil when no errors" do
    form = Components::ModelForm.new(model: @deal, action: "/deals")

    assert_nil form.field_error(:description)
  end

  test "uses POST method for new records" do
    new_deal = Deal.new
    form = Components::ModelForm.new(model: new_deal, action: "/deals")

    assert_equal :post, form.method
  end

  test "uses PATCH method for persisted records" do
    @deal.save!
    form = Components::ModelForm.new(model: @deal)

    assert_equal :patch, form.method
  end

  test "renders form with model binding" do
    output = Components::ModelForm.new(model: @deal, action: "/deals").call do |form|
      form.section do |section|
        section.textarea :description, label: "Description"
      end
    end

    assert_match(/name="deal\[description\]"/, output)
    assert_match(/id="deal_description"/, output)
    assert_match(/Test Deal/, output)
  end

  test "renders form with model errors" do
    @deal.description = nil
    @deal.valid?

    output = Components::ModelForm.new(model: @deal, action: "/deals").call do |form|
      form.section do |section|
        section.textarea :description, label: "Description"
      end
    end

    assert_match(/aria-invalid="true"/, output)
    assert_match(/deal_description-error/, output)
  end
end
