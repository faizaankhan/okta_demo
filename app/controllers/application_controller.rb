class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_authentication
  before_action :require_authorization

  def require_authentication
    redirect_to '/saml/login' if session[:email].nil?
  end

  def require_authorization; end
end
