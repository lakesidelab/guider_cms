require_dependency "guider_cms/application_controller"

module GuiderCms
  class CurrentUserArticlesController < ApplicationController
    def index
      if current_user && is_guider_admin
        @articles = Article.where(author_id: current_user.id)
        @root = Category.where(is_root_category: true).first.classification
      else
        redirect_to guider_home_path
      end
    end
  end
end
