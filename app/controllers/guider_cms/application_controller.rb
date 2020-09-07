module GuiderCms
  class ApplicationController < ::ApplicationController
    # rescue_from NoMethodError, :with => :render_404
    # protect_from_forgery with: :exception
    layout 'application'


    # def render_404
    #   render 'errors/404', :status => '404'
    # end
  end
end
