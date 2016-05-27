class ApplicationController < ActionController::Base
  before_action :authenticate

  protected

  rescue_from Exception do |exception|
    render_exception(exception)
  end

#Renderers
  def render_ok(json_object)
  	render json: json_object, status: :ok
  end

  def render_created(json_object)
  	render json: json_object, status: :created
  end

  def render_bad_request(message = nil)
  	responce = { message: message || "Incorrect parameters", stacktrace: caller[0, 10] }
  	render json: responce.as_json, status: :bad_request
  end

  def render_error(message = nil)
  	responce = { message: message || "Internal server error", stacktrace: caller[0, 10] }
  	render json: responce.as_json, status: :internal_server_error
  end

  def render_forbidden(message = nil)
  	responce = { message: message || "Access denied", stacktrace: caller[0, 10] }
  	render json: responce.as_json, status: :forbidden
  end

  def render_not_found(message = nil)
  	responce = { message: message || "Resource not found", stacktrace: caller[0, 10] }
  	render json: responce.as_json, status: :not_found
  end

  def render_exception(e)
    error_info = {
      :error => "Internal server error",
      :exception => "#{e.class.name} : #{e.message}",
    }
    error_info[:stacktrace] = e.backtrace[0,10] if Rails.env.development?
    render :json => error_info.to_json, :status => :internal_server_error
  end
#

#Autentication

  def current_user
    token = request.headers['auth-token']
    user = User.where(token: token).first
    return user
  end

  def authenticated?
    authenticate_token
  end

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    token = request.headers['auth-token']
    user = User.where(token: token).first
    return user.present? && !user.token_expired?
  end

  def render_unauthorized
    responce = { message: "Unauthorized access", stacktrace: caller[0, 10] }
    render json: responce.as_json, status: :unauthorized
  end
#
end
