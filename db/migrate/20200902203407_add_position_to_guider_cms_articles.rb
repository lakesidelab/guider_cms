class AddPositionToGuiderCmsArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :guider_cms_articles, :position, :integer
  end
end
