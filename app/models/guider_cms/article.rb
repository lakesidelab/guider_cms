module GuiderCms
  class Article < ApplicationRecord

    extend FriendlyId
    friendly_id :title, use: :slugged

    belongs_to :author, class_name: GuiderCms.author_class
    belongs_to :category
    has_rich_text :body
    has_one_attached :header_image
    has_many_attached :images
    before_validation :set_author

    validates :title, presence: true
    validates :body, presence: true
    validates :description, presence: true

    private
    def set_author
      self.author = GuiderCms.author_class.constantize.find(author_id)
    end

  end
end
