class DogProfile < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: { scope: :user_id, message: "has already been taken for this user." }
  validates :age, numericality: { only_integer: true, greater_than: 0 }
  validates :weight, numericality: { only_integer: true, greater_than: 0 }

end
