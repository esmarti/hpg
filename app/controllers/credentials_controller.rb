class CredentialsController < ApplicationController
  before_action :set_credential, only: %i[ show edit update destroy ]

  # GET /credentials or /credentials.json
  # show all credentials of selected user
  def index
    @user = User.find(params[:user_id])
    @credentials = @user.owned_credentials
  end

  # GET /credentials/1 or /credentials/1.json
  def show
    @credential = Credential.find(params[:id])
    @user = @credential.owner
  end

  # GET /credentials/new
  def new
    @user = User.find(params[:user_id])
    @credential = @user.owned_credentials.build
  end

  # GET /credentials/1/edit
  def edit
  end

  # POST /credentials or /credentials.json
  def create
    @credential = Credential.new(credential_params)
    @user = User.find(params[:user_id])
    @credential.owner = User.find(params[:user_id])
    @teamArr = Team.all.to_a
    
    respond_to do |format|
      if @credential.save
        format.html { redirect_to credential_url(@credential), notice: "Credential was successfully created." }
        format.json { render :show, status: :created, location: @credential }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /credentials/1 or /credentials/1.json
  def update
    respond_to do |format|
      if @credential.update(credential_params)
        format.html { redirect_to credential_url(@credential), notice: "Credential was successfully updated." }
        format.json { render :show, status: :ok, location: @credential }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credentials/1 or /credentials/1.json
  def destroy
    @credential.destroy!

    respond_to do |format|
      format.html { redirect_to user_credentials_url(@credential.owner), notice: "Credential was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credential
      @credential = Credential.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def credential_params
      params.require(:credential).permit(:username, :pass, :description, :team_id)
    end
end
