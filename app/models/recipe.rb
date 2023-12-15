class Recipe < ApplicationRecord
  has_many :ingredients
  has_many :steps
  accepts_nested_attributes_for :ingredients, :steps
  belongs_to :user
  has_many :comments
  has_many_attached :images

  def images_as_thumbnails
    images.map do |img|
      img.variant(resize_to_limit: [450,450]).processed
    end
  end
end
