class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path, status: :see_other
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "flash.user.signup_success"
      redirect_to @user, status: :see_other
    else
      flash.now[:danger] = t "flash.user.signup_failure"
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit User::ATTRIBUTES
  end
end
