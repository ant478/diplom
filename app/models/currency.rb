class Currency < ActiveRecord::Base
	has_many :deals
	has_many :payment_infos
	has_many :products
end
