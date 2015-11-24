class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?, :log_in!, :log_out!

  def log_in!(user)
    session[:session_token] = user.reset_session_token!
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def signed_in?
    !!current_user
  end

  def log_out!
    if signed_in?
      current_user.reset_session_token!
      session[:session_token] = nil
    else
      return nil
    end
  end

  def require_logged_in!
    redirect_to new_session_url unless signed_in?
  end
end
