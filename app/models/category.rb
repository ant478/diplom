class Category < ActiveRecord::Base
  has_many :products
  has_many :properties

  UPDATE_FIELDS = [
    "name", 
    "description", 
    "avatar_link", 
    "is_archived"
  ]

  SEARCH_FIELDS = [
    "name",
    "is_archived"
  ]

  def self.new_from_params(params)
    category = category.new
    category.name = params[:name]
    category.description = params[:description]
    category.avatar_link = params[:avatar_link]
    if params[:properties] && params[:properties].is_a?(Array)
      params[:properties].each { |property_params|
        property = Property.new_from_params(property_params)
        property.save
        category.properties.push(property)
      }
    end
    return category
  end

  def update_allowed_fields(params)
    UPDATE_FIELDS.each{ |field|
      self[field] = params[field] if params[field].present?
    }
    if params[:properties] && params[:properties].is_a?(Array)      
      existing_ids = self.properties.pluck(:id)
      updated_properties = params[:properties].select{ |property| property[:id] }
      updated_ids = updated_properties.map{ |property| property[:id] } #select where id exists
      new_properties = params[:properties].select{ |property| !property[:id] } #select where no id
      deleted_ids = existing_ids - updated_ids;

      updated_properties.each{ |property_params|
        property = Property.where(id: property_params[:id]).first
        property.update_allowed_fields(property_params)
        property.save
      }

      new_properties.each{ |property_params|
        property = Property.new_from_params(property_params)
        property.save
        self.properties.push(property)
      }

      Property.where(id: deleted_ids).delete_all
    end
  end

  def self.where_params(params)
    clean_params = {}
    SEARCH_FIELDS.each{ |field|
      clean_params[field] = params[field] if params[field]
    }
    return Category.where(clean_params)
  end

  def archived?
    self.is_archived
  end
end
