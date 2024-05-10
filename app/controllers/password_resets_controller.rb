class PasswordResetsController < ApplicationController
  before_action :load_user,
                :valid_user,
                :check_reset_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "flash.reset_password.reset_instructions"
      redirect_to root_url
    else
      flash.now[:danger] = t "flash.reset_password.email_not_found"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if user_params[:password].empty?
      flash.now[:warning] = t "flash.reset_password.not_empty"
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "flash.reset_password.reset_success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    redirect_to root_path, status: :see_other
    flash[:danger] = t "flash.user.not_exist"
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    redirect_to root_path, status: :see_other
    flash[:danger] = t "flash.reset_password.in_activated"
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_reset_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "flash.reset_passwordreset_expired"
    redirect_to new_password_reset_url
  end
end
