class Recipe < ApplicationRecord
  has_many :ingredients
  has_many :steps
  accepts_nested_attributes_for :ingredients, :steps
  belongs_to :user
  has_many :comments
  has_one_attached :recipe_card
  has_one_attached :image

  def image_as_thumbnail
      image.variant(resize_to_limit: [450,450]).processed
  end

  def recipe_card_as_thumbnail
    recipe_card.variant(resize_to_limit: [450,450]).processed
end
end
