class ApplicationController < ActionController::Base
    def current_user
        @current_user ||= session[:current_user_id] &&
        User.find_by(id: session[:current_user_id])
    end

    def is_guider_admin
      @current_user =  User.find_by(id: session[:current_user_id])
      if @current_user != nil and @current_user.email == 'admin@mail.com'
        @is_guider_admin = true
      else
        @is_guider_admin = false
      end
    end
end
