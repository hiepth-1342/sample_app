class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale
  include Pagy::Backend

  def logged_in_user
    return if logged_in?

    store_return_to_url
    redirect_to login_path, status: :see_other
    flash[:danger] = t "flash.login.pls_login"
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
