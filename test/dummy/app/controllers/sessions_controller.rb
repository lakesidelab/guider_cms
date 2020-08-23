class SessionsController < ApplicationController
  # "Create" a login, aka "log the user in"
  def create;
    user = User.find_by(email: params["email"])
    if user and user.password == params["password"]
      session[:current_user_id] = user.id
      redirect_to root_path
   end
  end

  def destroy
    # Remove the user id from the session
    session[:current_user_id] = nil
    redirect_to root_path
  end
end
