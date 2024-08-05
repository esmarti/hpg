class Admin::DashboardController < ApplicationController
	before_action :authenticate_user!
	before_action :admin_only

	def index
		# show admin dashboard
	end

  private
    # Only allow a user with admin role.
    def admin_only
      unless current_user.admin?
        redirect_to root_path, :alert => "Access denied."
      end
    end
end