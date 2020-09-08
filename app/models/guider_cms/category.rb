module GuiderCms
  class Category < ApplicationRecord
    extend FriendlyId
    friendly_id :classification, use: :slugged
    has_closure_tree
    has_one_attached :header_image
    has_many :articles
    validates :classification, presence: true

    private
    def should_generate_new_friendly_id?
      slug.blank? || classification_changed?
    end
  end


end
