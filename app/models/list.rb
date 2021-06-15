class List < ApplicationRecord
  has_many :cards, -> { order(position: :asc) }, dependent: :destroy

  acts_as_list

  validates :name, presence: true

  scope :sorted, -> { order(position: :asc) }
end
