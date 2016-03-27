class Deal < ActiveRecord::Base
	belongs_to :buyer, class_name: "User", foreign_key: "buyer_id"
	belongs_to :seller, class_name: "User", foreign_key: "seller_id"
	has_many :transactions
	belongs_to :currency
	belongs_to :product
end
