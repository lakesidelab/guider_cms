require 'test_helper'

module GuiderCms
  class ArticlesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
      @article = guider_cms_articles(:one)
      @root_category = guider_cms_categories(:root)
      @children_category = guider_cms_categories(:two)
      @actual = guider_cms_categories(:actual)
      @category = guider_cms_categories(:one)
    end

    test "should get index with no context" do
      get guider_home_url
      assert_response :success
    end

    test "should get new with a root" do
      get content_new_back_url(root: @root_category.classification)
      assert_response :success
    end

    test "should get new with root category and subcategory" do
      get contents_path(root: @root_category.classification, selected_category: @children_category.classification)
      assert_response :success
    end

    test "should get new" do
      sign_in('admin', 'admin@mail.com', 'password')
      get guider_cms.new_content_url(root: @root_category.classification)
      assert_response :success
    end

    test "should not get new without session" do
      get new_content_url(root: @root_category.classification)
      assert_redirected_to guider_home_url
    end

    test "should not get new without access" do
      sign_in('test', 'test@mail.com', 'password')
      get guider_cms.new_content_url(root: @root_category.classification)
      assert_redirected_to guider_home_url
    end

    # test "should create article" do
    #   sign_in('admin', 'admin@mail.com', 'password')
    #   assert_difference('Article.count') do
    #     post guider_cms.articles_url, params: {article: {title: @article.title, description: @article.description, body: @article.body, category_id: @children_category.id, author_id: @article.author_id}}
    #   end
    #   assert_redirected_to guider_home_url
    # end

    test "should get edit" do
      sign_in('admin', 'admin@mail.com', 'password')
      get guider_cms.edit_content_url(@article, root: @root_category.classification, selected_category: @actual.classification)
      assert_response :success
    end

    test "should not get edit without access" do
      sign_in('test', 'test@mail.com', 'password')
      get guider_cms.edit_content_url(@article, root: @root_category.classification, selected_category: @actual.classification)
      assert_redirected_to guider_home_url
    end

    test "should delete article" do
      sign_in('admin', 'admin@mail.com', 'password')
      assert_difference('Article.count', -1) do
        delete guider_cms.article_url(@article)
      end
      assert_redirected_to guider_home_url
    end

    test "should not delete article" do
      sign_in('test', 'test@mail.com', 'password')
      delete guider_cms.article_url(@article)
      assert_redirected_to guider_home_url
    end

    private
    def sign_in(name, email, password)
      post login_url, params: { name: name, email: email, password: password }
    end


  end
end
