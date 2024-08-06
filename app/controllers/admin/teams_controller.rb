class Admin::TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[ show edit update destroy ]
  before_action :admin_only

  # GET /teams or /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1 or /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(name: team_params[:name], description: team_params[:description], owner: User.find_by(id: team_params[:owner]))

    respond_to do |format|
      if @team.save
        format.html { redirect_to admin_team_path(@team), notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    owner = User.find_by(id: team_params[:owner])
    
    respond_to do |format|
      if @team.update( name: team_params[:name], description: team_params[:description], owner: owner )
        format.html { redirect_to admin_teams_url, notice: "Team was successfully updated." }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    if @team.user_ids.count > 0
      redirect_to admin_teams_path, alert: "Can't delete team with members."
      return
      if @team.credentials.count > 0
        redirect_to admin_teams_path, alert: "Can't delete team with credentials."
        return
      end
    else
      @team.destroy!

      respond_to do |format|
        format.html { redirect_to admin_teams_path, notice: "Team was successfully destroyed." }
        format.json { head :no_content }
      end
    end 
  end

   private
    # Only allow a user with admin role.
    def admin_only
      unless current_user.admin?
        redirect_to root_path, :alert => "Access denied."
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.fetch(:team, {}).permit(:name, :description, :owner)
    end
end
