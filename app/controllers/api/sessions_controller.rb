class Api::SessionsController < ApplicationController
	skip_before_action :authenticate, only: :create
  #before_action :check_params, only: :create

  def create
    user = User.find_by_email(params[:user][:email])
    if user.present?
      if user[:encrypted_password] == Digest::SHA2.hexdigest(params[:user][:password])
      	user.generate_token
      	user.save
      	render_ok({token: user.token})
      else
      	render_forbidden
      end
    else
      render_forbidden
    end
  end

  def destroy
    current_user.expire_token
    if current_user.save
      render_ok
    else
      render_error
    end    
  end

  def check_params
    render_bad_request if params[:user].blank? || !params[:user].is_a?(Hash)
  end
end
