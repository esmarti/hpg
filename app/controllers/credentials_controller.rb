class CredentialsController < ApplicationController
  before_action :set_credential, only: %i[ show edit update destroy ]

  # GET /credentials or /credentials.json
  # show all credentials of selected user
  def index
    @user = User.find(params[:user_id])
    #@credentials = @user.owned_credentials
    @credentials = Credential.find_by_sql("SELECT * FROM credentials WHERE encrypted_for_id = #{@user.id}")
  end

  # GET /credentials/1 or /credentials/1.json
  def show
    @page_libs = [:pgpKeyGenerate]
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
    # if user has no gpg key, redirect to user_credentials_path with error.
    user = User.find(params[:user_id])
    if user.gpg_key_id == nil
      redirect_to user_credentials_url(user), notice: "User has no gpg Key defined yet."
      return
    end

    team = Team.find(params[:credential][:team_id])

    team.users.each do |member|
      if member.gpg_key_id != nil
        credential = Credential.new(credential_params)
        # Set himself as owner of the credential. This is not editable by the user. You wouldn't be able to create credentials in the name of another user.
        credential.owner = user
        # Replace the clear-text password with the encrypted one.
        credential.pass = encrypt_pass(member, credential.pass)
        credential.encrypted_for = member
        credential.save
      end
    end

    credentialToRedirect = user.owned_credentials.order(created_at: :desc).first
  
    respond_to do |format|
        format.html { redirect_to user_credential_url(user, credentialToRedirect), notice: "Credential was successfully created." }
        format.json { render :show, status: :created, location: credentialToRedirect }
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
    @user = params[:user_id]
    @credential.destroy!

    respond_to do |format|
      format.html { redirect_to user_credentials_url(@user), notice: "Credential was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def encrypt_pass(user, pass)
      # this function is a helper to encrypt the password given, using the user's public key.
      return nil if user.gpg_key_id == nil
      userPublicKey = (user.gpg_key).gpg_public_key
      
      # import user public key
      GPGME::Key.import(userPublicKey)
      # generate data structure with secret to encrypt, in this case the pass.
      data = GPGME::Data.new(pass)
      # generate a new encrypter, setup "armor" mode (ASCII out) 
      # and "always_trust" (to avoid passphrase popup).
      crypto = GPGME::Crypto.new(:armor => true, :always_trust => true)
      # encrypt data with user's public key
      encriptedPass = crypto.encrypt(data, :recipients => user.email)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_credential
      @credential = Credential.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def credential_params
      params.require(:credential).permit(:username, :pass, :description, :team_id, :owner_id)
    end
end
