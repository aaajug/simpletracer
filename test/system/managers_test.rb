require "application_system_test_case"

class ManagersTest < ApplicationSystemTestCase
  setup do
    @manager = managers(:one)
  end

  test "visiting the index" do
    visit managers_url
    assert_selector "h1", text: "Managers"
  end

  test "creating a Manager" do
    visit managers_url
    click_on "New Manager"

    fill_in "Addedby", with: @manager.addedBy
    fill_in "Managerid", with: @manager.managerId
    fill_in "Password", with: @manager.password
    click_on "Create Manager"

    assert_text "Manager was successfully created"
    click_on "Back"
  end

  test "updating a Manager" do
    visit managers_url
    click_on "Edit", match: :first

    fill_in "Addedby", with: @manager.addedBy
    fill_in "Managerid", with: @manager.managerId
    fill_in "Password", with: @manager.password
    click_on "Update Manager"

    assert_text "Manager was successfully updated"
    click_on "Back"
  end

  test "destroying a Manager" do
    visit managers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Manager was successfully destroyed"
  end
end
