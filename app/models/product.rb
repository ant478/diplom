class Product < ActiveRecord::Base
	belongs_to :user, class_name: "User", foreign_key: "owner_id"
	has_many :comments
	has_many :deals
	belongs_to :currency
	belongs_to :category
	has_many :property_values
end
