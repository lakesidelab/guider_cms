require_dependency "guider_cms/application_controller"

module GuiderCms
  class CategoriesController < ApplicationController
    before_action :set_category, only: [:show, :edit, :update, :destroy]


    def index
      @all_categories = Category.all
      if @all_categories == []
        redirect_to new_optimized_category_path
      else
        @categories = Category.where(parent_id: nil)
        @root_category = Category.where(is_root_category: true).first
      end
    end

    def new
      if current_user && is_guider_admin
        @root = Category.where(is_root_category: true).first
        @category = Category.new
        @categories = Category.all
        @view_type = ["full grid", "blog grid", "blog list", "ordered list", "ordered grid", "normal grid with menu"]
        @root_categories = Category.where(is_root_category: true)
        # @root_categories = category_options_array()
      else
        redirect_to main_app.root_path, alert: "Not authorized"
      end
    end

    def edit
      if !(current_user)
        redirect_to guider_home_path
      else
        if !(is_guider_admin)
          redirect_to guider_home_path
        else
          @root_categories = Category.where(is_root_category: true)
          @view_type = ["full grid", "blog grid", "blog list", "ordered list", "ordered grid", "normal grid with menu"]
        end
      end
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to root_categories_path
      else
        render :new
      end
    end

    def update
      if @category.update(category_params)
        # if @category.update(category_params)
          redirect_to root_categories_path
      else
          render :edit
      end
    end

    def destroy
      if !!current_user && is_guider_admin
        if @category.articles == []
          @category.destroy
          @all_categories = Category.all
          if @all_categories != []
            redirect_to root_categories_path, notice: 'Categories was successfully destroyed.'
          else
            redirect_to guider_home_path
          end
        else
          redirect_to root_categories_path, alert: "Only Empty Categories can be deleted."
        end
      else
        redirect_to guider_home_path
      end
    end


    private
    def set_category
      @category = Category.friendly.find(params[:id])
      if @category.parent
        @root_id = @category.parent
      else
        @root_id = nil
      end
    end

    def category_params
      params.require(:category).permit(:classification, :parent_id, :view_type, :header_image, :slug)
    end
  end
end
