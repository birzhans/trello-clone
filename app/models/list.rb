class List < ApplicationRecord
  has_many :cards, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true
  scope :sorted, -> { order(position: :asc) }

  acts_as_list

end
