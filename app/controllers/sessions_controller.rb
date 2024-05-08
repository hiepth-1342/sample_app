class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.try(:authenticate, params.dig(:session, :password))
      log_in user
      if params.dig(:session, :remember_me) == Settings.remember_me_checked
        remember(user)
      else
        forget(user)
      end

      flash[:success] = t "flash.user.login_success"
      redirect_back user
    else
      flash.now[:danger] = t "flash.user.login_failure"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
