class Api::UsersController < ApplicationController
  skip_before_action :authenticate, only: :create
  before_action :check_params, except: :index

  def index
    users = User.where_params(params[:user])
    users = users.map{ |user| user.as_json_short }
    render_ok({users: users}.as_json)
  end

  def show
    binding.pry
    user = User.where(id: params[:user][:id]).first if params[:user][:id]
    user = User.where(id: params[:user][:token]).first if params[:user][:token]
    render_ok user.to_json_full if user.present?
    render_not_found if user.blank?
  end

  def create
    if params[:user][:password] != params[:user][:password_confirmation] || !User.password_valid?(params[:user][:password])
      render_bad_request("Password is invalid") and return
    end
    if User.exists?(email: params[:user][:email])
      render_bad_request("Users with this email already exists") and return
    end
    if User.exists?(login: params[:user][:login])
      render_bad_request("Users with this login already exists") and return
    end

    user = User.new_from_params(params[:user])
    if user.save
      render_created(user.as_json_full)
    else
      render_bad_request("Some parameters are invalid")
    end
  end

  def update
    user = User.where(id: params[:user][:id]).first
    if user.present?
      if params[:user][:password] == params[:user][:password_confirmation] && User.password_valid?(params[:user][:password]) && 
         (current_user.can_moderate? || current_user.id == user.id)
        user.update_password(params[:user])
      else
        user.update_allowed_fields(params[:user]) if current_user.can_moderate? || current_user.id == user.id
        if params[:user][:role_id].present?
          user.add_users_permissions if params[:user][:role_id] == Role.find_by_name("User").id && current_user.can_create_priveleged_users?
          user.add_privileged_permissions if params[:user][:role_id] == Role.find_by_name("Privileged").id && current_user.can_create_priveleged_users?
          user.add_moderators_permissions if params[:user][:role_id] == Role.find_by_name("Moderator").id && current_user.can_create_moderators?
        end
      end
      if user.save
        render_ok(user.as_json_full)
      else
        render_bad_request
      end
    else
      render_not_found
    end
  end

  def destroy
    if current_user.can_moderate?
      user = User.where(id: params[:user][:id]).first
      if user.present?
        user.is_archived = true
        user.save
        render_ok
      else
        render_not_found
      end
    else
      render_forbidden
    end
  end

  private

  def check_params
    render_bad_request if params[:user].blank? || !params[:user].is_a?(Hash)
  end
end
