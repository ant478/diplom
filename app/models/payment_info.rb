class PaymentInfo < ActiveRecord::Base
  belongs_to :user
  belongs_to :currency

  UPDATE_FIELDS = [
    "name", 
    "data"
  ]

  def self.new_from_params(params)
    payment_info = PaymentInfo.new
    payment_info.name = params[:name]
    payment_info.data = params[:data]
    payment_info.currency_id = params[:currency_id]
    return payment_info
  end

  def update_allowed_fields(params)
    UPDATE_FIELDS.each{ |field|
      self[field] = params[field] if params[field].present?
    }
  end
end
