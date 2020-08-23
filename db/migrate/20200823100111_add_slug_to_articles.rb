class AddSlugToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :guider_cms_articles, :slug, :string
    add_index :guider_cms_articles, :slug, unique: true
  end
end
