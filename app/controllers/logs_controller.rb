class LogsController < ApplicationController
  before_action :auth, only: %i[ trace create]
  before_action :set_log, only: %i[ edit update destroy ]

  # GET /logs or /logs.json by
  def index
    @logs = Log.all
  end

  # GET /logs/1 or /logs/1.json
  def list
    # show appropriate logs ordered by time descending
    if session[:account] == "establishment"
      if params['name'].strip != session[:name].strip
        redirect_to '/' + session[:name] + "/logs"
      end
      @logs = Log.where(establishmentId: session[:currentId]).joins("LEFT JOIN establishments ON logs.establishmentId = establishments.id").select(:fullname, :email, :mobile, :created_at, 'establishments.estname as estname').order(created_at: :desc)
    elsif session[:account] == "manager"
      if params['name'] == 'all'
        @estName = "Viewing all logs"
        @logs = Log.select("logs.*, estname").joins('LEFT JOIN establishments ON logs.establishmentId = establishments.id').order(created_at: :desc)
      else
        if request.original_fullpath.split('/',3)[1] != 'manager'
          redirect_to '/manager' + request.original_fullpath
        end
        @estName = view_params['name']
        @logs = Log.joins("LEFT JOIN establishments ON logs.establishmentId = establishments.id").select(:fullname, :email, :mobile, :created_at, 'establishments.estname as estname').where("establishments.estname='"+@estName+"'").order(created_at: :desc)
      end
    end 
  end

  # GET /logs/new
  def new
    @log = Log.new
  end

  def trace
    @log = Log.new
  end

  # GET /logs/1/edit
  def edit
  end

  def daterange
    if session[:account] == 'manager'
      if params['establishmentName'] != 'Viewing all logs'
        @logs = Log.joins('LEFT JOIN establishments ON logs.establishmentId == establishments.id').where(' establishments.estname = ? AND logs.created_at BETWEEN ? AND ? ', params['establishmentName'] ,params[:startdate].to_date,params[:enddate].to_date+1).order(created_at: :desc)
        @displayEstName = params['establishmentName']
      elsif params['establishmentName'] == 'Viewing all logs'
        @logs = Log.select("establishments.estname", "logs.*").joins('LEFT JOIN establishments ON logs.establishmentId == establishments.id').where(' logs.created_at BETWEEN ? AND ? ' ,params[:startdate].to_date,params[:enddate].to_date+1).order(created_at: :desc)
        @displayEstName = 'set_to_all'

      end
    elsif session[:account] == 'establishment'
      @logs = Log.where(establishmentId: session[:currentId]).where('logs.created_at BETWEEN ? AND ? ', params[:startdate].to_date,params[:enddate].to_date+1).order(created_at: :desc)
      @displayEstName = session[:name]
    end

    respond_to do | format |
      format.js
    end
  end

  def findByMail
    # visited 5 days prior to case date
    @data = "accepted"
    print "\n\nparameters: "
    print params
    print "end of parameters\n\n"

    @info = Log.where(email: email_lookup_params['email']).distinct.select(:mobile, :fullname)
    
    if session[:account] == "manager"
      print "========="
      print email_lookup_params['email']
      print "========="
      @ownLogs = Log.where(email: email_lookup_params['email']).order(created_at: :desc)#.joins("LEFT JOIN establishments ON logs.establishmentId = establishments.id").select(:created_at, 'establishments.estname as estname')

      # establishment visitors within 2 hours
      @otherContacts = Log.all
    elsif session[:account] == "establishment"
    else
      redirect_to '/'
    end

    respond_to do |format|
      format.js
    end
  end

  # POST /logs or /logs.json
  def create
    @log = Log.new(log_params)
    @log.establishmentId = session[:currentId]   

    respond_to do |format|
      if @log.save
        format.html { redirect_to '/'+session[:name]+'/trace', notice: "Log was successfully created." }
        format.json { render :show, status: :created, location: @log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logs/1 or /logs/1.json
  def update
    respond_to do |format|
      if @log.update(log_params)
        format.html { redirect_to @log, notice: "Log was successfully updated." }
        format.json { render :show, status: :ok, location: @log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logs/1 or /logs/1.json
  def destroy
    @log.destroy
    respond_to do |format|
      format.html { redirect_to logs_url, notice: "Log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def auth
      if session[:account] != 'establishment'
        redirect_to '/'
      elsif session[:account] == 'establishment'
        if !params['name'].nil?
          if params['name'].strip != session[:name].strip
            redirect_to '/' + session[:name] + "/" + request.fullpath.split('/')[-1]
          end
        end
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = Log.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def log_params
      params.require(:log).permit(:fullname, :email, :mobile)
    end

    def view_params
      params.permit(:name)
    end

    def email_lookup_params
      params.permit(:email)
    end
end
