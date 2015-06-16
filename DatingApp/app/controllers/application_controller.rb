class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_filter :last_sign_in_at, if: proc { user_signed_in? && (session[:last_sign_in_at] == nil || session[:last_sign_in_at] < 10.minutes.ago) }
  # before_filter :days_ago_in_words
  after_action :update_last_activity
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

  def update_last_activity
    current_user.try :touch
  end

  # def days_ago_in_words(time)
  #   days = ((Time.now - time.to_time) / 86400.0).round
  #   if days > 1
  #     I18n.t :x_days, :count => days, :scope => :'datetime.distance_in_words'
  #   else
  #     time_ago_in_words(time)
  #   end
  # end

  # private

  # def last_sign_in_at
  #   current_user.update_attribute(:last_sign_in_at, Time.now)
  #   session[:last_sign_in_at] = Time.now
  # end
  
end
  # def last_activity
  #   current_time = Time.now
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

