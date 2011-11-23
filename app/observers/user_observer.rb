class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    UserNotifier.registration(user).deliver
  end
  
end
