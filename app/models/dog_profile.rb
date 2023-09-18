class DogProfile < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }
  validates :weight, numericality: { only_integer: true, greater_than: 0 }
end
