class PropertyParameter < ActiveRecord::Base
  belongs_to :propertySW

  UPDATE_FIELDS = [
    "key", 
    "value"
  ]

  def self.new_from_params(params)
    property_parameter = PropertyParameter.new
    property_parameter.key = params[:key]
    property_parameter.value = params[:value]
    return property_parameter
  end

  def update_allowed_fields(params)
    UPDATE_FIELDS.each{ |field|
      self[field] = params[field] if params[field].present?
    }
  end
end
