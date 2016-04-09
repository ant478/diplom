class Api::CategoriesController < ApplicationController
  before_action :check_params

  def index
    categories = Category.where_params(params[:category])
    categories = categories.map{ |category| category.as_json_full }
    render_ok({ categories: categories }.as_json)
  end

  def show
    category = category.where(id: params[:category][:id]).first if params[:category][:id]
    render_ok category.to_json_full if category.present?
    render_not_found if category.blank?
  end

  def create
    if current_user.can_create_categories?
      category = Category.new_from_params(params[:category])
      if category.save
        render_created(category.as_json_full)
      else
        render_bad_request("Some parameters are invalid")
      end
    else
      render_forbidden
    end
  end

  def update
    if current_user.can_create_categories?
      category = Category.where(id: params[:category][:id]).first
      if category.present?
        category.update_allowed_fields(params[:category])
        if category.save
          render_ok(category.to_json_full)
        else
          render_bad_request("Some parameters are invalid")
        end
      else
        render_not_found
      end
    else
      render_forbidden
    end
  end

  def destroy
    if current_user.can_create_categories?
      category = Category.where(id: params[:category][:id]).first
      if category.present?
        category.is_archived = true
        category.save
        render_ok
      else
        render_not_found
      end
    else
      render_forbidden
    end
  end

  def check_params
    render_bad_request if params[:category].blank? || !params[:category].is_a?(Hash)
  end
end
