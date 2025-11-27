require "test_helper"

class Components::FormTest < ActiveSupport::TestCase
  test "renders form with action" do
    output = Components::Form.new(action: "/deals").call

    assert_match(/<form/, output)
    assert_match(/action="\/deals"/, output)
    assert_match(/method="post"/, output)
  end

  test "renders form with method spoofing" do
    output = Components::Form.new(action: "/deals/1", method: :patch).call

    assert_match(/method="post"/, output)
    assert_match(/<input[^>]*type="hidden"[^>]*name="_method"[^>]*value="patch"/, output)
  end

  test "renders form with space-y-12 container" do
    output = Components::Form.new(action: "/deals").call

    assert_match(/space-y-12/, output)
  end

  test "renders form with sections" do
    output = Components::Form.new(action: "/deals").call do |form|
      form.section(title: "Personal Info") do |section|
        section.text :name, label: "Name"
      end
    end

    assert_match(/Personal Info/, output)
    assert_match(/Name/, output)
  end

  test "generates field names" do
    form = Components::Form.new(action: "/test")

    assert_equal "email", form.field_name(:email)
    assert_equal "first_name", form.field_name(:first_name)
  end

  test "generates field IDs" do
    form = Components::Form.new(action: "/test")

    assert_equal "email", form.field_id(:email)
    assert_equal "first-name", form.field_id(:first_name)
  end

  test "returns explicit field values" do
    form = Components::Form.new(action: "/test")

    assert_equal "test@example.com", form.field_value(:email, "test@example.com")
    assert_nil form.field_value(:email, nil)
  end
end
