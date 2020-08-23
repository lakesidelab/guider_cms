class CreateGuiderCmsArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :guider_cms_articles do |t|
      t.text :title
      t.text :description
      t.text :body
      t.integer :category_id
      t.integer :author_id

      t.timestamps
    end
  end
end
