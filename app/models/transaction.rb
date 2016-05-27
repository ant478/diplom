class Transaction < ActiveRecord::Base
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"
  belongs_to :sender_payment_info, class_name: "PaymentInfo", foreign_key: "sender_payment_info_id"
  belongs_to :reseiver_payment_info, class_name: "PaymentInfo", foreign_key: "reseiver_payment_info_id"
  belongs_to :deal

  SEARCH_FIELDS = [
    "sender_id",
    "receiver_id",
    "deal_id",
    "sender_payment_info_id",
    "reseiver_payment_info_id",
    "currency_id"
  ]

  RANGE_SEARCH_FIELDS = [
    "price",
    "created_at"
  ]

  def self.where_params(params)
    clean_params = {}
    SEARCH_FIELDS.each{ |field|
      clean_params[field] = params[field] if params[field]
    }
    transactions = Transaction.where(clean_params)
    RANGE_SEARCH_FIELDS.each{ |field| 
      transactions = transactions.where(params[field])
    }
    return transactions
  end

end
