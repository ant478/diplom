class Property < ActiveRecord::Base
	belongs_to :property_type
	belongs_to :category
	has_many :property_values
	has_many :property_parameters

  UPDATE_FIELDS = [
    "name", 
    "description"
  ]

  def self.new_from_params(params)
    property = Property.new
    property.name = params[:name]
    property.description = params[:description]
    if params[:property_parameters] && params[:property_parameters].is_a?(Array)
      params[:property_parameters].each { |property_parameter_param|
        property_parameter = PropertyParameter.new_from_params(property_parameter_param)
        property_parameter.save
        property.property_parameters.push(property_parameter)
      }
    end
    return property
  end

  def update_allowed_fields(params)
    UPDATE_FIELDS.each{ |field|
      self[field] = params[field] if params[field].present?
    }
    if params[:property_parameters] && params[:property_parameters].is_a?(Array)
      existing_ids = self.property_parameters.pluck(:id)
      updated_property_parameters = params[:property_parameters].select{ |property_parameter| property_parameter[:id] }
      updated_ids = updated_property_parameters.map{ |property_parameter| property_parameter[:id] } #select where id exists
      new_property_parameters = params[:property_parameters].select{ |property_parameter| !property_parameter[:id] } #select where no id
      deleted_ids = existing_ids - updated_ids;

      updated_property_parameters.each{ |property_parameter_params|
        property_parameter = PropertyParameter.where(id: property_parameter_params[:id]).first
        property_parameter.update_allowed_fields(property_parameter_params)
        property_parameter.save
      }

      new_properties.each{ |property_parameter_params|
        property_parameter = PropertyParameter.new_from_params(property_parameter_params)
        property_parameter.save
        self.property_parameters.push(property_parameter)
      }

      PropertyParameter.where(id: deleted_ids).delete_all
    end
  end
end
