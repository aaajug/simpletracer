class SavedReportsController < ApplicationController
  before_action :set_saved_report, only: %i[ show edit update destroy ]

  # GET /saved_reports or /saved_reports.json
  def index
    @saved_reports = SavedReport.all
  end

  # GET /saved_reports/1 or /saved_reports/1.json
  def show
  end

  # GET /saved_reports/new
  def new
    @saved_report = SavedReport.new
  end

  # GET /saved_reports/1/edit
  def edit
  end

  # POST /saved_reports or /saved_reports.json
  def create
    @saved_report = SavedReport.new(saved_report_params)

    respond_to do |format|
      if @saved_report.save
        format.html { redirect_to @saved_report, notice: "Saved report was successfully created." }
        format.json { render :show, status: :created, location: @saved_report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @saved_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /saved_reports/1 or /saved_reports/1.json
  def update
    respond_to do |format|
      if @saved_report.update(saved_report_params)
        format.html { redirect_to @saved_report, notice: "Saved report was successfully updated." }
        format.json { render :show, status: :ok, location: @saved_report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @saved_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /saved_reports/1 or /saved_reports/1.json
  def destroy
    @saved_report.destroy
    respond_to do |format|
      format.html { redirect_to saved_reports_url, notice: "Saved report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_saved_report
      @saved_report = SavedReport.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def saved_report_params
      params.require(:saved_report).permit(:email, :name, :caseDate, :linkToFile)
    end
end
