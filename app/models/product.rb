class Product < ApplicationRecord
    has_one_attached :image

    validates :name, :description, :price, presence: true
    validates :price, numericality: { greater_than: 0 }

    belongs_to :user
    has_many :orders
    
    paginates_per 8
end
