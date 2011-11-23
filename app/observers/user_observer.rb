class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    UserMailer.registration(user).deliver
  end
  
end
