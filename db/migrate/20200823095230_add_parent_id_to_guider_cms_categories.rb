class AddParentIdToGuiderCmsCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :guider_cms_categories, :parent_id, :integer
  end
end
