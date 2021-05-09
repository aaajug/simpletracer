require "application_system_test_case"

class EstablishmentsTest < ApplicationSystemTestCase
  setup do
    @establishment = establishments(:one)
  end

  test "visiting the index" do
    visit establishments_url
    assert_selector "h1", text: "Establishments"
  end

  test "creating a Establishment" do
    visit establishments_url
    click_on "New Establishment"

    fill_in "Name", with: @establishment.name
    fill_in "Password", with: @establishment.password
    click_on "Create Establishment"

    assert_text "Establishment was successfully created"
    click_on "Back"
  end

  test "updating a Establishment" do
    visit establishments_url
    click_on "Edit", match: :first

    fill_in "Name", with: @establishment.name
    fill_in "Password", with: @establishment.password
    click_on "Update Establishment"

    assert_text "Establishment was successfully updated"
    click_on "Back"
  end

  test "destroying a Establishment" do
    visit establishments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Establishment was successfully destroyed"
  end
end
