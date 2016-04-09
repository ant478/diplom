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
    if params[:property_values] && params[:property_values].is_a?(Array)
      params[:property_values].each { |property_params|
        property_value = PropertyValue.new_from_params(property_value_params)
        property_value.save
        product.property_value_values.push(property_value)
      }
    end
    return product
  end

  def update_allowed_fields(params)
    UPDATE_FIELDS.each{ |field|
      self[field] = params[field] if params[field].present?
    }
    if params[:property_values] && params[:property_values].is_a?(Array)      
      existing_ids = self.property_values.pluck(:id)
      updated_property_values = params[:property_values].select{ |property_value| property_value[:id] }
      updated_ids = updated_property_values.map{ |property_value| property_value[:id] } #select where id exists
      new_property_values = params[:property_values].select{ |property_value| !property_value[:id] } #select where no id
      deleted_ids = existing_ids - updated_ids;

      updated_property_values.each{ |property_value_params|
        property_value = PropertyValue.where(id: property_value_params[:id]).first
        property_value.value = property_value_params[:value]
        property_value.save
      }

      new_property_values.each{ |property_value_params|
        property_value = PropertyValue.new
        property_value.value = property_value_params[:value]
        property_value.property_id = property_value_params[:property_id]
        property_value.product_id = self.id
        property_value.save
        self.property_values.push(property)
      }

      PropertyValue.where(id: deleted_ids).delete_all
    end
  end

  def self.where_params(params)
    clean_params = {}
    SEARCH_FIELDS.each{ |field|
      clean_params[field] = params[field] if params[field]
    }
    return Category.where(clean_params)
  end
end
