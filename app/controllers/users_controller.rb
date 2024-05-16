class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :logged_in_user, only: %i(edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.all, items: Settings.page_12)
  end

  def show
    @page, @microposts = pagy @user.microposts, items: Settings.page_5
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "flash.account.check_email_to_activate"
      redirect_to login_url
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

  def following
    @title = t "pages.following.following_title"
    @page, @users = pagy @user.following, items: Settings.page_9
    render :show_follow, status: :unprocessable_entity
  end

  def followers
    @title = t "pages.following.followers_title"
    @page, @users = pagy @user.followers, items: Settings.page_9
    render :show_follow, status: :unprocessable_entity
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
