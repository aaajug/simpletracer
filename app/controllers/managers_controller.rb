class ManagersController < ApplicationController
  before_action :auth, except: %i[ login verify ] 
  before_action :set_manager, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: %i[findByMail]


  # GET /managers or /managers.json
  # Landing page for manager accounts
  def index
    if session[:currentId].nil?
      redirect_to '/manager/login'
    else
      @establishments = Establishment.order(:id, name: :desc)
    end
  end

  def list
    @managers = Manager.all
  end

  # GET /managers/new
  def new
    @manager = Manager.new
  end

  def initialize
    session[:account] = "manager"
    session[:currentId] = "root"
    redirect_to '/maneger/add'
  end

  def findByMail
    # visited 5 days prior to case date

    @info = Log.where(email: email_lookup_params['email']).distinct.select(:mobile, :fullname)
    @email = email_lookup_params['email']
    @startdate = params[:startdate]
    @enddate = params[:enddate]

    @confirmedcase = false
    
    if session[:account] == "manager"
      if params[:casedate] == 'true'
        @confirmedcase = true

        @ownLogs = Log.where(email: @email).joins("LEFT JOIN establishments ON logs.establishmentId = establishments.id").select('logs.created_at', 'establishments.estname as estname').where('logs.created_at BETWEEN ? AND ? ', params[:startdate].to_date,params[:enddate].to_date+1).order("logs.created_at DESC")

        @otherContacts = Log.distinct.where('logs2.email != \''+@email+'\'').select('logs.establishmentId', 'estname', 'logs2.fullname', 'logs2.email', 'logs2.mobile', 'logs2.created_at').where(email: @email).where('logs.created_at BETWEEN ? AND ? ', params[:startdate].to_date,params[:enddate].to_date+1).joins('LEFT JOIN logs AS logs2 ON logs.establishmentId = logs2.establishmentId AND logs2.created_at BETWEEN datetime(logs.created_at, "-2 hour") AND datetime(logs.created_at, "+2 hour")').joins('LEFT JOIN establishments ON logs.establishmentId == establishments.id').order("logs.created_at DESC")
      elsif params[:casedate] == 'false' and !params[:startdate].nil? and !params[:enddate].nil?
        @otherContacts = nil
        @ownLogs = Log.where(email: @email).joins("LEFT JOIN establishments ON logs.establishmentId = establishments.id").select('logs.created_at', 'establishments.estname as estname').where('logs.created_at BETWEEN ? AND ? ', params[:startdate].to_date,params[:enddate].to_date+1).order("logs.created_at DESC")
      else
        @otherContacts = nil
        @ownLogs = Log.where(email: @email).joins("LEFT JOIN establishments ON logs.establishmentId = establishments.id").select(:created_at, 'establishments.estname as estname').order(created_at: :desc)
      end

      # establishment visitors within 2 hours
      # @otherContacts = Log.all  
      # print "===== others: " + @otherContacts.empty?.to_s + "  == end =="
      # print @otherContacts[0]
      # print "\n\n printed \n\n"
    elsif session[:account] == "establishment"
      @ownLogs = Log.where(establishmentId: session[:currentId]).joins("LEFT JOIN establishments ON logs.establishmentId = establishments.id").select('logs.created_at', 'establishments.estname as estname').where('logs.created_at BETWEEN ? AND ? ', params[:startdate].to_date,params[:enddate].to_date).order("logs.created_at DESC")
    else
      redirect_to '/'
    end

    respond_to do |format|
      format.js
    end
  end

  # show login page for mall managers
  def login
    if !session[:currentId].nil?
      redirect_to '/manager/overview'
    end
  end

  # POST /login
  # check if manager ID exists and if password macthes
  def verify
    @error = nil
    password = Digest::SHA256.hexdigest(login_params['password'])
    managerpw = Manager.where(managerId: login_params['managerId']).pluck :password

    respond_to do |format|
      if !managerpw.empty? and managerpw[0] == password
          session[:account] = "manager"
          session[:currentId] = login_params['managerId']
          format.html { redirect_to '/manager/overview' }
      else
        @error = "Incorrect manager ID and/or password."
        format.html { render :login, status: :unprocessable_entity }
      end
    end
  end

  # POST /managers or /managers.json
  # Add new manager account
  # Only a logged-in manager can add new manager accounts
  def create
    @manager = Manager.new(manager_params)
    @manager.password = Digest::SHA256.hexdigest(@manager.password)
    @manager.addedBy = session[:currentId]

    respond_to do |format|
      if @manager.save
        format.html { redirect_to @manager, notice: "Manager was successfully created." }
        format.json { render :show, status: :created, location: @manager }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /managers/1 or /managers/1.json
  def update
    respond_to do |format|
      if @manager.update(manager_params)
        format.html { redirect_to @manager, notice: "Manager was successfully updated." }
        format.json { render :show, status: :ok, location: @manager }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /managers/1 or /managers/1.json
  def destroy
    @manager.destroy
    respond_to do |format|
      format.html { redirect_to managers_url, notice: "Manager was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def logout
    session[:currentId] = nil
    session[:account] = nil
    redirect_to '/'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def auth
      if session[:account] != "manager" or session[:currentId].empty?
       redirect_to '/'
      end 
    end

    def set_manager
      @manager = Manager.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def manager_params
      params.require(:manager).permit(:managerId, :password, :addedBy)
    end

    def login_params
      params.permit(:managerId, :password)
    end

    def email_lookup_params
      params.permit(:email)
    end
end
