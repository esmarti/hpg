class TeamsController < ApplicationController
  before_action :authenticate_user!  
  before_action :set_team, only: %i[ show edit update destroy ]

  # GET /teams or /teams.json
  # Shows all teams of the current user
  def index
    #@teams = Team.all
    @user = User.find(params[:user_id])
    filter_current_user(@user)

    @teams = @user.teams
  end

  # GET /teams/1 or /teams/1.json
  def show
    @user = User.find(params[:user_id])
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
    @user = User.find(params[:user_id])
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to team_url(@team), notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to team_url(@team), notice: "Team was successfully updated." }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy!

    respond_to do |format|
      format.html { redirect_to teams_url, notice: "Team was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Only current user logged in is able to see this page
    def filter_current_user(user)
      unless user == current_user
        redirect_to user_teams_path(current_user), :alert => "Access denied."
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.fetch(:team, {})
    end
end
