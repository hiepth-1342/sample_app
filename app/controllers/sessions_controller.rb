class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase

    if user&.authenticate params.dig(:session, :password)
      log_in user
      flash[:success] = t "flash.user.login_success"
      redirect_to user, status: :see_other
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
