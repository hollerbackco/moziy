class UserObserver < ActiveRecord::Observer
  def after_create(user)
    if Rails.env.production?
      UserMailer.registration(user).deliver
    end
  end
end
