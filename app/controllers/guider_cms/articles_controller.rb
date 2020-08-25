require_dependency "guider_cms/application_controller"

module GuiderCms
  class ArticlesController < ApplicationController
    before_action :set_article, only: [:edit, :update, :destroy]
    # before_action :is_guider_assesible, only: [:new, :edit, :update, :destroy]
    # before_action :is_correct_user, only: [:edit, :update, :destroy]
    # GET /articles
    def index
      @guider_admin = is_guider_admin
      @user_signed_in = current_user
      @articles = Article.all
      @root = params[:root]
      @selected_category = params[:selected_category]
      if @root.nil?
        @root_category = Category.where(is_root_category: true).first
        if @root_category.nil?
          redirect_to new_optimized_category_path, notice: "Create a root category first"
        else
          @root = @root_category.classification
          @children_category = @root_category.children
          if @children_category.nil?
            redirect_to new_optimized_category_path, notice: "Create category for #{@root}"
          else
            @selected_category_class = @children_category.first
          end
        end
      else
        @root_category = Category.find_by(classification: @root)
        @children_category = @root_category.children
        if @selected_category.nil?
          if @children_category.first.nil?
            redirect_to new_optimized_category_path, alert: "No category found for #{@root}, Please create one"
          else
            @selected_category_class = @children_category.first
          end
        else
          # @selected_category_class = Category.find_by(classification: @selected_category)
          if Category.find_by(classification: @selected_category).nil?
            @selected_category_class = Category.find_by(slug: @selected_category)
          else
            @selected_category_class = Category.find_by(classification: @selected_category)
          end

        end
      end
    end

    # GET /articles/1
    def show
      @article = Article.friendly.find(params[:id])
      @coming_from = params[:action_from]
      @root = params[:root]
      @selected_category = params[:selected_category]
      @selected_category_class = Category.find_by(classification: @selected_category)
    end

    # GET /articles/new
    def new

      if current_user && is_guider_admin

        @root = params[:root]
        if @root.nil?
          redirect_to guider_home_path
        else
          @root_category = Category.find_by(classification: @root)
          rough = []
          @total = []
          @categories = @root_category.children
          @categories.each do |category|
            if category.children
              category.children.each do |subcategory|
                rough.append(subcategory)
              end
            end
          end

          @categories.each do |category|
            @total.append(category)
          end

          rough.each do |elements|
            @total.append(elements)
          end

          if @total.nil?
            redirect_to new_optimized_category_path
          else
            @article = Article.new
          end
        end
      else
        redirect_to guider_home_path
      end

    end

    # GET /articles/1/edit
    def edit
      # @root = params[:root]
      # @categories = Category.all
      # @selected_category = Category.find(@article.category_id)
      # @root_category = @selected_category.ancestors.last
      if current_user && current_user.id != @article.author_id
        redirect_to guider_home_path
      else
        @root = params[:root]
        @categories = Category.all
        @selected_category = Category.find(@article.category_id)
        @root_category = @selected_category.ancestors.last
        rough = []
        @total = []
        @categories = @root_category.children
        @categories.each do |category|
          if category.children
            category.children.each do |subcategory|
              rough.append(subcategory)
            end
          end
        end

        @categories.each do |category|
          @total.append(category)
        end

        rough.each do |elements|
          @total.append(elements)
        end
      end
    end

    # POST /articles
    def create
      @categories = Category.all
      @article = Article.new(article_params)


      @selected_category = Category.find(@article.category_id)
      # @root_category = @selected_category.ancestors.last

      @article.author_id = current_user.id

      if @article.save
        # redirect_to content_path(@article, root: @root_category, selected_category: @selected_category.classification), notice: 'Article was successfully created.'
        redirect_to guider_home_path
      else
        render :new
      end
    end

    # PATCH/PUT /articles/1
    def update
      if @article.update(article_params)
        redirect_to user_articles_path, notice: 'Article was successfully updated.'
      else
        render :edit
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
        params.require(:article).permit(:title, :description, :body, :category_id, :author_id, :header_image, :root)
      end
  end
end
