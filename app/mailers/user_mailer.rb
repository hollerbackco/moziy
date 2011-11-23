class UserMailer < ApplicationMailer
  default :from => "mosey@mosey.tv"
  
  def registration(user)
    @user = user
    mail :to => "jnoh12388@gmail.com",
         :subject => "Welcome to mosey.tv"
  end
  
  def reset_password_email(user)
    @user = user
    
    @url  = edit_password_reset_url(user.reset_password_token)
    
    mail(:to => "jnoh12388@gmail.com",
         :subject => "Your password reset request")
  end

end
