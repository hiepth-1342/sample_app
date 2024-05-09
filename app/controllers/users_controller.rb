class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :logged_in_user, only: %i(edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.all, items: Settings.per_page_user)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      handle_successful_signup
    else
      handle_failed_signup
    end
  end

  def edit; end

  def update
    if @user.update user_params
      redirect_to @user
      flash[:success] = t "flash.user.update_success"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "flash.user.destroy_success"
    else
      flash[:danger] = t "flash.user.destroy_failure"
    end
    redirect_to users_path, status: :see_other
  end

  private
  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def user_params
    params.require(:user).permit User::ATTRIBUTES
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path, status: :see_other
    flash[:danger] = t "flash.user.not_exist"
  end

  def logged_in_user
    return if logged_in?

    store_return_to_url
    redirect_to login_path, status: :see_other
    flash[:danger] = t "flash.user.login_before_update"
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "flash.user.cant_update_account"
    redirect_to root_path, status: :see_other
  end

  def handle_successful_signup
    log_in(@user)
    flash[:success] = t "flash.user.signup_success"
    redirect_to @user, status: :see_other
  end

  def handle_failed_signup
    flash.now[:danger] = t "flash.user.signup_failure"
    render :new, status: :unprocessable_entity
  end
end
