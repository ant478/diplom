class Property < ActiveRecord::Base
	belongs_to :property_type
	belongs_to :category
	has_many :property_values
	has_many :property_parameters
end
