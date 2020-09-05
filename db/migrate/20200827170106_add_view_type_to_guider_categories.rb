class AddViewTypeToGuiderCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :guider_cms_categories, :view_type, :string
  end
end
