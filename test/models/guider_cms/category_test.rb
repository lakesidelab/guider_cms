require 'test_helper'

module GuiderCms
  class CategoryTest < ActiveSupport::TestCase
    setup do
      @routes = Engine.routes
      @category = guider_cms_categories(:one)
      @root_category = guider_cms_categories(:root)
    end

    test "the truth" do
      assert true
    end

    test "should have a classification" do
      category = Category.new(classification: nil)
      assert_not category.save, "Saved without a classification"
    end
  end
end
