class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :last_sign_in_at, if: proc { user_signed_in? && (session[:last_sign_in_at] == nil || session[:last_sign_in_at] < 10.minutes.ago) }
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :birthday, :zipcode) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :is_female, :birthday, :zipcode) }
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:warning] = 'Resource not found.'
    redirect_back_or root_path
  end
 
  def redirect_back_or(path)
    redirect_to request.referer || path
  end


  private

  def last_sign_in_at
    current_user.update_attribute(:last_sign_in_at, Time.now)
    session[:last_sign_in_at] = Time.now
  end
  
end
  # def last_activity
  #   current_time = DateTime.now
  #   "last activity: " +
  #     if updated_at > current_time - 1.minute
  #       "now"
  #     elsif updated_at > current_time - 1.hour
  #       pluralize(((current_time.to_i - updated_at.to_i) / 60), 'minute') + " ago"
  #     elsif updated_at > current_time - 1.day
  #       pluralize(((current_time.to_i - updated_at.to_i) / 3600), 'hour') + " ago"
  #     else
  #       pluralize(((current_time.to_i - updated_at.to_i) / 86400), 'day') + " ago"
  #     end
  # end

