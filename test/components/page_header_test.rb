require "test_helper"

class Components::PageHeaderTest < ActiveSupport::TestCase
  test "renders title" do
    output = Components::PageHeader.new("Back End Developer").call

    assert_match(/Back End Developer/, output)
    assert_match(/text-2xl\/7 font-bold/, output)
  end

  test "renders without actions" do
    output = Components::PageHeader.new("My Title").call

    assert_match(/My Title/, output)
    refute_match(/button/, output)
  end

  test "renders with secondary action" do
    output = Components::PageHeader.new("My Title").call do |header|
      header.action("Edit", href: "/edit")
    end

    assert_match(/Edit/, output)
    assert_match(/href="\/edit"/, output)
    assert_match(/bg-white/, output)
    refute_match(/bg-indigo-600/, output)
  end

  test "renders with primary action" do
    output = Components::PageHeader.new("My Title").call do |header|
      header.action("Publish", href: "/publish", primary: true)
    end

    assert_match(/Publish/, output)
    assert_match(/bg-indigo-600/, output)
    assert_match(/hover:bg-indigo-700/, output)
  end

  test "renders multiple actions" do
    output = Components::PageHeader.new("My Title").call do |header|
      header.action("Edit", href: "/edit")
      header.action("Publish", href: "/publish", primary: true)
    end

    assert_match(/Edit/, output)
    assert_match(/Publish/, output)
    # Verifica que o segundo botão tem margin-left
    assert_match(/ml-3/, output)
  end

  test "renders button without href" do
    output = Components::PageHeader.new("My Title").call do |header|
      header.action("Delete", data_confirm: "Are you sure?")
    end

    assert_match(/<button/, output)
    assert_match(/Delete/, output)
    assert_match(/data-confirm/, output)
    refute_match(/<a/, output)
  end

  test "renders link with href" do
    output = Components::PageHeader.new("My Title").call do |header|
      header.action("View", href: "/show")
    end

    assert_match(/<a/, output)
    assert_match(/View/, output)
    assert_match(/href="\/show"/, output)
  end

  test "passes custom attributes to actions" do
    output = Components::PageHeader.new("My Title").call do |header|
      header.action("Custom", href: "/custom", class: "custom-class", id: "my-button")
    end

    assert_match(/custom-class/, output)
    assert_match(/id="my-button"/, output)
  end
end
