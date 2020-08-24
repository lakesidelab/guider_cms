module GuiderCms
  class Category < ApplicationRecord
    extend FriendlyId
    friendly_id :classification, use: :slugged
    has_closure_tree
    has_many :articles
    validates :classification, presence: true
  end
end
