require_dependency "guider_cms/application_controller"

module GuiderCms
  class CategoriesController < ApplicationController
    before_action :set_category, only: [:show, :edit, :update, :destroy]


    def index
      @all_categories = Category.all
      if @all_categories == []
        redirect_to new_optimized_category_path
      else
        @categories = Category.where(is_root_category: true)
        @root = Category.where(is_root_category: true).first.classification
      end
    end

    def new
      if current_user && is_guider_admin
        @root = Category.where(is_root_category: true).first
        @category = Category.new
        @root_categories = Category.where(is_root_category: true)
      else
        redirect_to guider_home_path
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
        end
      end
    end

    def create
      if params[:category]["root_id"].nil?
        @category = Category.new(classification: params[:category]["classification"], is_root_category: true)
        if @category.save
          redirect_to root_categories_path
        else
          render :new
        end
      else
        category = Category.find_by(classification: params[:category]["root_id"])
        category.children.create(classification: params[:category]["classification"])
        redirect_to root_categories_path
      end
    end

    def update
      if params[:category]["root_id"] == ""
        if @category.update(classification: params[:category]["classification"], parent_id: nil)
          redirect_to main_app.root_path
        end
      else
        parent_category = Category.find_by(classification: params[:category]["root_id"])
        in_que_category = Category.find_by(classification: params[:category]["classification"])
        in_que_category.parent_id = parent_category.id
        if in_que_category.update(category_params)
          redirect_to root_categories_path
        else
          render :edit
        end
      end
      # if params[:category]["parent_id"] == "" && params[:category]["root_id"] == ""
      #   redirect_to new_category_path, alert: "parent or section atleast one of them must be filled"
      # else
      #   if params[:category]["parent_id"] == ""
      #
      #     category = Category.find_by(classification: params[:category]["root_id"])
      #     que_category = Category.find_by(classification: params[:category]["classification"])
      #     que_category.parent_id = category.id
      #     if que_category.update(category_params)
      #       redirect_to articles_path
      #     else
      #       render :edit
      #     end
      #     # redirect_to articles_path
      #
      #   else
      #     category = Category.find_by(classification: params[:category]["parent_id"])
      #     que_category = Category.find_by(classification: params[:category]["classification"])
      #     que_category.parent_id = category.id
      #     if que_category.update(category_params)
      #       redirect_to articles_path
      #     else
      #       render :edit
      #     end
      #     # redirect_to articles_path
      #   end
      # end
    end

    def populate_category_list
    root = params[:root]
    # puts(country)
    if root == ""
      @normal_categories = []
    else
      #converting string to a atom, request gives a string(eg "IN" for india).
      # symbolized_country = country.parameterize.underscore.to_sym #"IN" -> :in
      # @states = CS.get(symbolized_country)
      # @states = ["tn", "mh"]
      # puts(@states)
      @normal_categories = Category.find_by(classification: root).children
    end
    #responding to the get request wit a json object
    respond_to do |format|
      format.json { render json: @normal_categories }
    end
  end



    def destroy
      if !!current_user && is_guider_admin
        if @category.articles == []
          @category.destroy
          redirect_to root_categories_path, notice: 'Categories was successfully destroyed.'
        else
          redirect_to root_categories, alert: "Only Empty Categories can be deleted."
        end
      else
        redirect_to guider_home_path
      end
    end


    private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:classification, :parent)
    end
  end
end
