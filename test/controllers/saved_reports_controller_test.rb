require "test_helper"

class SavedReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @saved_report = saved_reports(:one)
  end

  test "should get index" do
    get saved_reports_url
    assert_response :success
  end

  test "should get new" do
    get new_saved_report_url
    assert_response :success
  end

  test "should create saved_report" do
    assert_difference('SavedReport.count') do
      post saved_reports_url, params: { saved_report: { caseDate: @saved_report.caseDate, email: @saved_report.email, linkToFile: @saved_report.linkToFile, name: @saved_report.name } }
    end

    assert_redirected_to saved_report_url(SavedReport.last)
  end

  test "should show saved_report" do
    get saved_report_url(@saved_report)
    assert_response :success
  end

  test "should get edit" do
    get edit_saved_report_url(@saved_report)
    assert_response :success
  end

  test "should update saved_report" do
    patch saved_report_url(@saved_report), params: { saved_report: { caseDate: @saved_report.caseDate, email: @saved_report.email, linkToFile: @saved_report.linkToFile, name: @saved_report.name } }
    assert_redirected_to saved_report_url(@saved_report)
  end

  test "should destroy saved_report" do
    assert_difference('SavedReport.count', -1) do
      delete saved_report_url(@saved_report)
    end

    assert_redirected_to saved_reports_url
  end
end
