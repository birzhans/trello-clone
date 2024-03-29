class Card < ApplicationRecord
  belongs_to :list

  validates :name, presence: true

  acts_as_list scope: :list
end
