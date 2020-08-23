class AddIsRootCategoryRoGuiderCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :guider_cms_categories, :is_root_category, :boolean
  end
end
