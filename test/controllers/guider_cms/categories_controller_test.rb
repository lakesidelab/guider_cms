require 'test_helper'

module GuiderCms
  class CategoriesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
      @category = guider_cms_categories(:one)
      @root_category = guider_cms_categories(:root)
    end

    test "should get index" do
      get root_categories_url
      assert_response :success
    end


    test "should get new" do
      sign_in('admin', 'admin@mail.com', 'password')
      get guider_cms.new_optimized_category_url
      assert_response :success
    end

    test "should not get new without session" do
      get new_optimized_category_url
      assert_redirected_to guider_home_url
    end

    test "should not get new without access" do
      sign_in('test', 'test@mail.com', 'password')
      get guider_cms.new_optimized_category_url
      assert_redirected_to guider_home_url
    end

    test "should create root category" do
      assert_difference('Category.count') do
        post categories_url, params: {category: {classification: 'Policies', root_id: nil}}
      end
      assert_redirected_to root_categories_url
    end

    test "should create children category" do
      assert_difference('Category.count') do
        post categories_url, params: {category: {classification: 'Privacy', root_id: @root_category.classification}}
      end
      assert_redirected_to root_categories_url
    end

    test "should get edit" do
      sign_in('admin', 'admin@mail.com', 'password')
      get guider_cms.edit_category_url(@category)
      assert_response :success
    end

    test "should not get edit without session" do
      get edit_category_url(@category)
      assert_redirected_to guider_home_url
    end

    test "should not get edit without access" do
      sign_in('test', 'test@mail.com', 'password')
      get guider_cms.edit_category_url(@category)
      assert_redirected_to guider_home_url
    end

    test "should update category" do
      patch category_url(@category), params: {category: {classification: @category.classification, root_id: @root_category.classification}}
      assert_redirected_to root_categories_url
    end

    test "should destroy article" do
      sign_in('admin', 'admin@mail.com', 'password')
      assert_difference('Category.count', -1) do
        delete guider_cms.category_url(@category)
      end
      assert_redirected_to root_categories_url
    end

    test "should not destroy without session" do
      delete category_url(@category)
      assert_redirected_to guider_home_url
    end

    test "should not destroy without access" do
      sign_in('test', 'test@mail.com', 'password')
      delete guider_cms.category_url(@category)
      assert_redirected_to guider_home_url
    end

    private
    def sign_in(name, email, password)
      post login_url, params: { name: name, email: email, password: password }
    end
  end
end
