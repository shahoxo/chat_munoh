class Forbidden < StandardError; end
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :login_required

  rescue_from Forbidden do |e|
    redirect_to root_path, :alert => 'Access denied.'
  end

  private
  def login_required
    raise Forbidden unless user?
  end

  def user?
    @user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
