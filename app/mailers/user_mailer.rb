class UserMailer < ApplicationMailer
  def registration(user)
    @user = user
    mail :to => @user.email,
         :subject => "Welcome to moziy.com"
  end

  def reset_password_email(user)
    @user = user

    @url  = edit_password_reset_url(user.reset_password_token)

    mail(:to => @user.email,
         :subject => "Your password reset request")
  end

end
