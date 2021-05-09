class EstablishmentsController < ApplicationController
  before_action :auth, except: %i[ login verify new create destroy]
  before_action :auth_add, only: %i[ new create destroy]
  before_action :set_establishment, only: %i[ show edit update destroy ]

  def index
    if params['name'].strip != session[:name].strip
      redirect_to '/establishment/' + session[:name]
    end
  end

  def login
    @establishments = Establishment.order('lower(estname) asc')
  end
 
  def verify
    @error = nil
    # password = Digest::SHA256.hexdigest(login_params['password'])
    est = Establishment.where(id: login_params['establishmentId']).pluck :estname

    respond_to do |format|
      # if !estpw.empty? and estpw[0] == password
        session[:account] = "establishment"
        session[:currentId] = login_params['establishmentId']
        session[:name] = est[0].strip
        format.html { redirect_to '/establishment/'+est[0].strip }
      # else
      #   @error = "Incorrect manager ID and/or password."
      #   format.html { render :login, status: :unprocessable_entity }
      # end
    end
  end

  # GET /establishments/1 or /establishments/1.json
  def show
  end

  # GET /establishments/new
  def new
    if session[:currentId].nil?
      redirect_to '/manager/login'
    end
    @establishment = Establishment.new
  end

  # GET /establishments/1/edit
  def edit
  end

  # POST /establishments or /establishments.json
  def create
    @establishment = Establishment.new(establishment_params)
    @establishment.password = Digest::SHA256.hexdigest(@establishment.password)
   

    respond_to do |format|
      if  @establishment.save
        format.js
      end
    end
  end

  def logout
    if !session[:account].nil? and !session[:currentId].nil?
      session[:account] = nil
      session[:currentId] = nil
    end

    redirect_to '/'
  end

  # PATCH/PUT /establishments/1 or /establishments/1.json
  def update
    respond_to do |format|
      if @establishment.update(establishment_params)
        format.html { redirect_to @establishment, notice: "Establishment was successfully updated." }
        format.json { render :show, status: :ok, location: @establishment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @establishment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /establishments/1 or /establishments/1.json
  def destroy
    @establishment.destroy
    respond_to do |format|
      format.js { render :create }
    end
  end

  private
    def auth
      if session[:account] != 'establishment' || session[:currentId].empty?
        redirect_to '/'
      end
    end

    def auth_add
      if session[:account] != 'manager'
        redirect_to '/'
      end
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_establishment
      @establishment = Establishment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def establishment_params
      params.require(:establishment).permit(:estname, :password)
    end

    def login_params
      params.permit(:establishmentId, :password, :establishmentName, :authenticity_token, :commit)
    end
end
