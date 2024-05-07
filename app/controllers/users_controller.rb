class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash.now[:success] = t "flash.user.signup_success"
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit User::Attributes
  end
end
