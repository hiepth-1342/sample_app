class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("flash.account.activation_subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("flash.account.passwors_reset_subject")
  end
end
