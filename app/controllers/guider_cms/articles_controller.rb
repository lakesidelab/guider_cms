require_dependency "guider_cms/application_controller"

module GuiderCms
  class ArticlesController < ApplicationController
    layout GuiderCms.layout || 'application'
    include GuiderCms::ArticlesHelper
    before_action :set_article, only: [:edit, :update, :destroy, :edit_article_position_one_backward, :edit_article_position_one_forward]
    # before_action :is_guider_assesible, only: [:new, :edit, :update, :destroy]
    # before_action :is_correct_user, only: [:edit, :update, :destroy]
    # GET /articles


    def index
      @root = params[:root]
      @is_guider_admin = is_guider_admin
      @current_user = current_user
      @selected_category = params[:selected_category]
      if @root.nil?
        @root_category = Category.where(is_root_category: true).first
        if @root_category.nil?
          redirect_to new_optimized_category_path, alert: "Create a root category first"
        else
          @root = @root_category.classification
          if @selected_category.nil?
            @selected_category_class = @root_category
            @children_category = @root_category.children.order(:id)
          end
        end
      else
        @root_category = Category.find_by(classification: @root) || Category.find_by(slug: @root)
        if @selected_category.nil?
          @selected_category_class = @root_category
        else
          @selected_category_class = Category.find_by(classification: @selected_category) || Category.find_by(slug: @selected_category)
        end
        @children_category = @root_category.children.order(:id)
      end
      if @root_category.view_type == "menu" || @root_category.view_type == "ordered list"
        if @root_category.articles == [] && @root_category.children != []
          @selected_category_class = @root_category.children.first
        end
      end
      if @root_category.view_type == "ordered list"
        if @root_category.children == []
          redirect_to new_optimized_category_path, notice: "Create a new category under #{@root_category.classification}"
        end
      end
      if @root_category.view_type == "blog grid" || @root_category.view_type == "blog list"
        @categories = category_options_array_for_article(nil, [], @root_category.id, 0)
        @articles_id = []

        @categories.each do |category|
          @required_category_class = Category.find_by(classification: category[0].gsub('&nbsp;', ''))
          @required_category_class.articles.each do |article|
            @articles_id.append(article.id)
          end
        end
        @articles = Article.where(id: @articles_id).order(updated_at: :desc).page params[:page]

        # @articles = Article.all.order(created_at: :desc).page params[:page]
      end
    end


    # GET /articles/1
    def show
      @article = Article.friendly.find(params[:id])
      @coming_from = params[:action_from]
      @root = params[:root]
      @selected_category = params[:selected_category]
      if Category.find_by(classification: @root).nil?
        @root_category = Category.find_by(slug: @root)
      else
        @root_category = Category.find_by(classification: @root)
      end
      if @selected_category.nil?
        @selected_category = @root
        @selected_category_class = @root_category
      else
        if Category.find_by(classification: @selected_category).nil?
          @selected_category_class = Category.find_by(slug: @selected_category)
        else
          @selected_category_class = Category.find_by(classification: @selected_category)
        end
      end
    end

    # GET /articles/new
    def new

      if current_user && is_guider_admin

        @root = params[:root]
        @article = Article.new
        if @root.nil?
          redirect_to guider_home_path
        else
          if Category.find_by(classification: @root).nil?
            @root_category = Category.find_by(slug: @root)
          else
            @root_category = Category.find_by(classification: @root)
          end

        end
      else
        redirect_to content_new_back_path(root: @root_category.slug || @root_category.classification)
      end

    end

    # GET /articles/1/edit
    def edit
      if current_user && current_user.id != @article.author_id
        redirect_to guider_home_path
      else
        @root = params[:root]
        @categories = Category.all
        @selected_category = Category.friendly.find(@article.category_id)
        if @selected_category.parent.nil?
          @root_category = @selected_category
        else
          @root_category = @selected_category.ancestors.last
        end
      end
    end

    # POST /articles
    def create
      @categories = Category.all
      @article = Article.new(article_params)


      @selected_category = Category.find(@article.category_id)
      @root_category = @selected_category.ancestors.last

      @article.author_id = current_user.id

      if @article.save
        if @root_category.nil?
          redirect_to content_new_back_path(root: @selected_category.slug || @selected_category.classification)
        else
          redirect_to content_path(@article, root: @root_category.slug || @root_category.classification, selected_category: @selected_category.slug || @selected_category.classification), notice: 'Article was successfully created.'
        end
        # redirect_to guider_home_path
      else
        render :new
      end
    end

    # PATCH/PUT /articles/1
    def update

      category_id = @article.category_id
      if @article.update(article_params)
        if @article.category_id != ""
          req_category_id = @article.category_id
        else
          req_category_id = category_id
        end
        @selected_category_class = Category.find(req_category_id)
        @root_category = @selected_category_class.ancestors.last
        # redirect_to user_articles_path, notice: 'Article was successfully updated.'
        if @root_category.nil?
          redirect_to content_new_back_path(root: @selected_category_class.slug || @selected_category_class.classification)
        else
          redirect_to content_path(@article, root: @root_category.slug || @root_category.classification, selected_category: @selected_category_class.slug || @selected_category_class.classification), notice: 'Article was successfully created.'
        end

        # redirect_to guider_home_path

      else
        render :edit
      end
    end

    def edit_article_position_one_backward
      root = params[:root]
      selected_category = params[:selected_category]
      @article.move_higher
      if selected_category == ""
        redirect_to content_new_back_path(root: root)
      else
        redirect_to contents_path(root: root, selected_category: selected_category)
      end
    end

    def edit_article_position_one_forward
      root = params[:root]
      selected_category = params[:selected_category]
      @article.move_lower
      if selected_category == ""
        redirect_to content_new_back_path(root: root)
      else
        redirect_to contents_path(root: root, selected_category: selected_category)
      end
    end

    # DELETE /articles/1
    def destroy
      if @article.author_id == current_user.id or is_guider_admin
        @article.destroy
        redirect_to guider_home_path, notice: 'Article was successfully destroyed.'
      else
        redirect_to guider_home_path, alert: "Cannot do that"
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def is_correct_user
        @article = Article.find(params[:id])
        if current_user.id != @article.author_id
          redirect_to root_path
        end
      end

      def is_guider_assesible
        # puts(current_user)
        if current_user and is_guider_admin?
          redirect_to root_path
        end
      end

      def set_article
        if Article.friendly.find(params[:id]).nil?
          @article = Article.find_by(slug: params[:id])
        else
          @article = Article.friendly.find(params[:id])
        end
      end

      # Only allow a trusted parameter "white list" through.
      def article_params
        params.require(:article).permit(:title, :description, :body, :category_id, :author_id, :header_image, :root, :keywords)
      end
  end
end
