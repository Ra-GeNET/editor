class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  http_basic_authenticate_with name: "rara", password: "shift123!@#"  
  before_action :set_theme_url

private

  def set_theme_url
    @theme_url = "/theme.css"
  end
  
end
