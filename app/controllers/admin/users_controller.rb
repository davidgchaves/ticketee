class Admin::UsersController < Admin::BaseController
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.order :email
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:notice] = "User has been created."
      redirect_to admin_users_path
    else
      flash[:alert] = "User has not been created."
      render :new
    end
  end

  def edit
  end

  def update
    delete_blank_password_from_params if params[:user][:password].blank?

    if @user.update(user_params)
      flash[:notice] = "User has been updated."
      redirect_to admin_users_path
    else
      flash[:alert] = "User has not been updated."
      render :edit
    end
  end

  def destroy
    if @user == current_user
      flash[:alert] = "You cannot delete yourself!"
    else
      @user.destroy
      flash[:notice] = "#{@user.email} has been deleted."
    end

    redirect_to admin_users_path
  end

  private

    def find_user
      @user = User.find params[:id]
    end

    def user_params
      params.require(:user).permit :name, :email, :password, :admin
    end

    def delete_blank_password_from_params
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
end
