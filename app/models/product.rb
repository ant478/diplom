class Product < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: "owner_id"
  has_many :comments
  has_many :deals
  belongs_to :currency
  belongs_to :category
  has_many :property_values

  UPDATE_FIELDS = [
    "name", 
    "description", 
    "price", 
    "quantity", 
    "is_paused", 
    "is_archived", 
    "is_blocked", 
    "currency_id", 
    "category_id"
  ]

  SEARCH_FIELDS = [
    "name",
    "is_archived",
    "category_id",
    "is_blocked",
    "is_paused",
    "is_archived"
  ]

  RANGE_SEARCH_FIELDS = [
    "price",
    "quantity",
    "created_at"
  ]

  def self.new_from_params(params)
    product = Product.new
    product.update_allowed_fields(params)
    return product
  end

  def update_allowed_fields(params)
    UPDATE_FIELDS.each{ |field|
      self[field] = params[field] if params[field].present?
    }
  end

  def self.where_params(params)
    clean_params = {}
    SEARCH_FIELDS.each{ |field|
      clean_params[field] = params[field] if params[field]
    }
    return Category.where(clean_params)
  end
end
