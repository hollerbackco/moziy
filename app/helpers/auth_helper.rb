module AuthHelper
  def authorization_for(provider)
    @authorization ||= current_user.authorizations.find_by_provider(provider)
  end
end
