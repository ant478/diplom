class User < ActiveRecord::Base
	belongs_to :country
	belongs_to :role
	has_many :incoming_transactions, class_name: "Transaction", foreign_key: "receiver_id"
	has_many :outcoming_transactions, class_name: "Transaction", foreign_key: "sender_id"
	has_many :sales, class_name: "Deal", foreign_key: "seller_id"
	has_many :purchases, class_name: "Deal", foreign_key: "buyer_id"
	has_many :payment_infos
	has_many :products
	has_many :comments

end
