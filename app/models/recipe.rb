class Recipe < ApplicationRecord
  has_many :ingredients
  has_many :steps
  accepts_nested_attributes_for :ingredients, :steps
  belongs_to :user
  has_many :comments
  has_one_attached :recipe_card
  has_one_attached :image

end
