class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /users/gpg_show/:id
  def gpg_show
    @user = User.find(params[:id])
    @page_libs = [:openpgp, :pgpKeyGenerate]
  end

  # POST /users/gpg_update/:id
  def gpg_update
    @user = User.find(params[:id])
    @user.gpg_key = GpgKey.build(description: "rsa4096", gpg_public_key: params[:pubKey])
 
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "GPG Public Key was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/gpg_destroy/:id
  def gpg_destroy
    @user = User.find(params[:id])
    @user.gpg_key=nil
    @user.save
    #userKey=GpgKey.find_by_id(User.find_by(id:4).gpg_key_id)
    #userKey.destroy!

    respond_to do |format|
      format.html { redirect_to users_gpg_show_url(@user), notice: "GPG Public Key was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {}).permit(:name, :lastname, :email, :role)
    end
end
