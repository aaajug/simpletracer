json.extract! saved_report, :id, :email, :name, :caseDate, :linkToFile, :created_at, :updated_at
json.url saved_report_url(saved_report, format: :json)
