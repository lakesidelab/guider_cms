require_dependency "guider_cms/application_controller"

module GuiderCms
  class SubcategoriesController < ApplicationController
    def new
      if current_user && is_guider_admin
        @root = params[:root]
        @root_category = Category.find_by(classification: @root)
        @categories = Category.where(parent_id: @root_category.id)
      else
        redirect_to content_new_back_path(root: @root)
      end
    end

    def create
      classification = params[:subcategory]["category"]
      subcategory = params[:subcategory]["subcategory"]
      # puts(classification)
      #
      #
      category = Category.find_by(classification: classification)
      puts(category.id)
      category.children.create(classification: subcategory)

      @root = category.ancestors.last.classification

      redirect_to content_new_back_path(root: @root)
    end

    private
    def article_params
      params.require(:subcategory).permit(:category, :subcategory)
    end
  end
end
