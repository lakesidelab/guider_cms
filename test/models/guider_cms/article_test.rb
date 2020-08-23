require 'test_helper'

module GuiderCms
  class ArticleTest < ActiveSupport::TestCase
    setup do
      @routes = Engine.routes
      @article = guider_cms_articles(:one)
      @root_category = guider_cms_categories(:root)
      @children_category = guider_cms_categories(:two)
      @actual = guider_cms_categories(:actual)
      @category = guider_cms_categories(:one)
    end

    test "the truth" do
      assert true
    end

    test "should not save article without title" do
      article = Article.new(title: nil, description: @article.description, body: @article.body, category_id: @children_category.id, author_id: @article.author_id)
      assert_not article.save, "Saved the article without a title"
    end

    test "should not save article without body" do
      article = Article.new(title: @article.title, description: @article.description, body: nil, category_id: @children_category.id, author_id: @article.author_id)
      assert_not article.save, "Saved the article without a body"
    end

    test "should not save article without description" do
      article = Article.new(title: @article.title, description: nil, body: @article.body, category_id: @children_category.id, author_id: @article.author_id)
      assert_not article.save, "Saved the article without a description"
    end
  end
end
