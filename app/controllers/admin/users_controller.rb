class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, only: %i[ index show edit update new create destroy ]
  before_action :set_user, only: %i[ show edit update destroy gpg_show gpg_update gpg_destroy ]

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
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
  #TODO: create new Team "Private for #{user.email}" for each new user and asignate it to the user as owner.
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_user_path(@user), notice: "User was successfully created." }
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
      if @user.update(name: user_params[:name], lastname: user_params[:lastname], email: user_params[:email], fullname: user_params[:name] + " " + user_params[:lastname], role: user_params[:role], password: user_params[:password], password_confirmation: user_params[:password_confirmation])
        format.html { redirect_to admin_user_path(@user), notice: "User was successfully updated." }
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
      format.html { redirect_to admin_users_path, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /users/gpg_show/:id
  def gpg_show
    @page_libs = [:openpgp, :pgpKeyGenerate]
  end

  # POST /users/gpg_update/:id
  def gpg_update
    @user.gpg_key = GpgKey.build(description: "rsa4096", gpg_public_key: params[:pubKey])
 
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_user_url(@user), notice: "GPG Public Key was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/gpg_destroy/:id
  def gpg_destroy
    credentials=Credential.find_by_sql("SELECT * FROM credentials WHERE encrypted_for_id = #{@user.id}")
    if credentials.empty?
      @user.gpg_key=nil
      @user.save
      #userKey=GpgKey.find_by_id(User.find_by(id:4).gpg_key_id)
      #userKey.destroy!

      respond_to do |format|
        format.html { redirect_to admin_users_gpg_show_url(@user), notice: "GPG Public Key was successfully destroyed." }
        format.json { head :no_content }
      end
    else # can't delete key if user has credentials.
      respond_to do |format|
        format.html { redirect_to admin_users_gpg_show_url(@user), alert: "You can't delete key if user has credentials." }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Only allow a user with admin role.
    def admin_only
      unless current_user.admin?
        #redirect_to user_path(current_user.id), :alert => "Access denied."
        redirect_to root_path, :alert => "Access denied."
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {}).permit(:name, :lastname, :email, :role, :password, :password_confirmation)
    end
end
