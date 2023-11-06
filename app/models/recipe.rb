class Recipe < ApplicationRecord
  has_many :ingredients
  has_many :steps
  accepts_nested_attributes_for :ingredients, :steps
  belongs_to :user
end
