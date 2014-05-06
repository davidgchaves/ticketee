class Admin::PermissionsController < Admin::BaseController
  before_action :find_user, only: [:index, :set]

  def index
    @ability = Ability.new @user
    @projects = Project.all
  end

  def set
    @user.permissions.clear

    set_new_user_permissions

    flash[:notice] = "Permissions updated."
    redirect_to admin_user_permissions_path(@user)
  end

  private

    def find_user
      @user = User.find params[:user_id]
    end

    def set_new_user_permissions
      params[:permissions].each do |id, permissions|
        project = Project.find id
        permissions.each do |permission, checked|
          Permission.create! user: @user, thing: project, action: permission
        end
      end
    end
end
