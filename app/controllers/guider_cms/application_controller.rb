module GuiderCms
  class ApplicationController < ::ApplicationController
    # rescue_from StandardError, :with => :render_404 
    # protect_from_forgery with: :exception
    layout 'application'


    def render_404
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end
end
