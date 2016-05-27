class Deal < ActiveRecord::Base
  belongs_to :buyer, class_name: "User", foreign_key: "buyer_id"
  belongs_to :seller, class_name: "User", foreign_key: "seller_id"
  has_many :transactions
  belongs_to :currency
  belongs_to :product

  def self.new_from_params(params)
    deal = Deal.new
    deal.product_id = params[:product_id]
    deal.seller_id = params[:seller_id]
    deal.price = params[:price]
    deal.currency_id = params[:currency_id]
    return deal
  end
end
