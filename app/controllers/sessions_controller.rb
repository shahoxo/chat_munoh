class SessionsController < ApplicationController
  skip_before_filter :login_required

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    if user.valid?
      session[:user_id] = user.id
      redirect_to rooms_url, :notice => "Signed in!"
    else
      redirect_to root_url, :alert => "Can not Login"
    end 
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

  def new
  end
end
