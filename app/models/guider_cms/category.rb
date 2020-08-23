module GuiderCms
  class Category < ApplicationRecord
    has_closure_tree
    has_many :articles
    validates :classification, presence: true
  end
end
