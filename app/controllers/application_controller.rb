class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def getuser params
  	username = params[:name]
	secret = params[:secret]
	user = User.find_by(name: username).try(:authenticate, secret)
  end
  
end
