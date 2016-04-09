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

  validates :email, uniqueness: true
  validates :login, uniqueness: true
  validates :token, uniqueness: true

  UPDATE_FIELDS = [
    "first_name", 
    "last_name", 
    "passport_id", 
    "avatar_url", 
    "address_line_1", 
    "address_line_2", 
    "post_index", 
    "phone_number", 
    "birth_date", 
    "country_id",
    "is_blocked",
    "is_archived"
  ]

  SEARCH_FIELDS = [
    "login",
    "email",
    "first_name", 
    "last_name", 
    "phone_number", 
    "country_id",
    "role_id",
    "is_blocked",
    "is_archived"
  ]

  def self.new_from_params(params)
    user = User.new
    user.login = params[:login]
    user.email = params[:email]
    user.update_allowed_fields(params)
    user.update_password(params)
    user.add_users_permissions
    user.generate_token
    if params[:payment_infos].present? && params[:payment_infos].is_a?(Array)
      params[:payment_infos].each{ |payment_info_params|
        payment_info = PaymentInfo.new_from_params(payment_info_params)
        payment_info.save
        user.payment_infos.push(payment_info)
      }
    end
    return user
  end

  def update_allowed_fields(params)
    UPDATE_FIELDS.each{ |field|
      self[field] = params[field] if params[field].present?
    }
    if params[:payment_infos].present? && params[:payment_infos].is_a?(Array)
      existing_ids = self.payment_infos.pluck(:id)
      updated_payment_infos = params[:payment_infos].select{ |payment_info| payment_info[:id] }
      updated_ids = update_payment_infos.map{ |payment_info| payment_info[:id] }
      new_payment_infos = params[:payment_infos].select{ |payment_info| !payment_info[:id] }
      deleted_ids = existing_ids - updated_ids;

      updated_payment_infos.each{ |payment_info_params|
        payment_info = PaymentInfo.where(id: payment_info_params[:id]).first
        payment_info.update_allowed_fields(payment_info_params)
        payment_info.save
      }

      new_payment_infos.each{ |payment_info_params|
        payment_info = PaymentInfo.new_from_params(payment_info_params)
        payment_info.save
        self.payment_infos.push(payment_info)
      }

      PaymentInfo.where(id: deleted_ids).delete_all
    end
  end

  def self.where_params(params)
    clean_params = {}
    SEARCH_FIELDS.each{ |field|
      clean_params[field.to_sym] = params[field.to_sym] if params[field.to_sym]
    }
    puts clean_params
    return User.where(clean_params)
  end

  def update_password(params)
    self.encrypted_password = Digest::SHA2.hexdigest(params[:password])
  end

  def add_users_permissions
    self.role = Role.find_by_name("User")
  end

  def add_privileged_permissions
    self.role = Role.find_by_name("Privileged")
  end

  def add_moderators_permissions
    self.role = Role.find_by_name("Moderator")
  end

  def add_admins_permissions
    self.role = Role.find_by_name("Admin")
  end

  def as_json_full
  	self.as_json(
  		only: [
  			:id,
  			:login,
        :email,
        :first_name,
        :last_name,
        :passport_id,
        :avatar_url,
        :address_line_1,
        :address_line_2,
        :post_index,
        :phone_number,
        :birth_date,
        :country_id,
        :role_id],
    	include: {
    		payment_infos: {
	    		:only => [
	    			:id,
	    			:name,
	    			:data,
	    			:currency_id]
    		}
    	}
    )
  end

  def as_json_short
  	self.as_json(
  		:only => [
  			:id,
  			:login,				
        :email,
        :first_name,
        :last_name,
        :avatar_url,
        :role_id
      ]
    )
  end

  def self.password_valid?(password)
    password.present? && password.is_a?(String) && password.length > 5
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(token: random_token)
    end
    self.token_expires_at = Time.now + 1.day
  end

  def token_expired?
    self.token_expires_at > Time.now
  end

  def expire_token
    self.token = Time.now
  end

  def owns_product?(product)
    product[:id].in?(self.products.pluck(:id))
  end

  def blocked?
    self.is_blocked
  end

  def archived?
    self.is_archived
  end

  def active?
    !self.is_blocked && !self.is_archived
  end

  def can_see_products?
    self.role.can_see_products
  end

  def can_create_products?
    self.role.can_create_products
  end

  def can_create_categories?
    self.role.can_create_categories
  end

  def can_buy_products?
    self.role.can_buy_products
  end

  def can_comment?
    self.role.can_comment
  end

  def can_moderate?
    self.role.can_moderate
  end 

  def can_chat?
    self.role.can_chat
  end

  def can_see_statistics?
    self.role.can_see_statistics
  end

  def can_create_moderators?
    self.role.can_create_moderators
  end

  def can_create_priveleged_users?
    self.role.can_create_priveleged_users
  end
end
