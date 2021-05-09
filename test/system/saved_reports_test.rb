require "application_system_test_case"

class SavedReportsTest < ApplicationSystemTestCase
  setup do
    @saved_report = saved_reports(:one)
  end

  test "visiting the index" do
    visit saved_reports_url
    assert_selector "h1", text: "Saved Reports"
  end

  test "creating a Saved report" do
    visit saved_reports_url
    click_on "New Saved Report"

    fill_in "Casedate", with: @saved_report.caseDate
    fill_in "Email", with: @saved_report.email
    fill_in "Linktofile", with: @saved_report.linkToFile
    fill_in "Name", with: @saved_report.name
    click_on "Create Saved report"

    assert_text "Saved report was successfully created"
    click_on "Back"
  end

  test "updating a Saved report" do
    visit saved_reports_url
    click_on "Edit", match: :first

    fill_in "Casedate", with: @saved_report.caseDate
    fill_in "Email", with: @saved_report.email
    fill_in "Linktofile", with: @saved_report.linkToFile
    fill_in "Name", with: @saved_report.name
    click_on "Update Saved report"

    assert_text "Saved report was successfully updated"
    click_on "Back"
  end

  test "destroying a Saved report" do
    visit saved_reports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Saved report was successfully destroyed"
  end
end
