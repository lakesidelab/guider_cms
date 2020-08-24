class AddSlugToGuiderCmsCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :guider_cms_categories, :slug, :string
    add_index :guider_cms_categories, :slug, unique: true
  end
end
