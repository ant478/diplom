class Api::ProductsController < ApplicationController
  def index
    if current_user.can_see_products? 
      #products = Product.where_params(params[:product])
      products = Product.all
      products = products.map{ |product| product.as_json }
      render_ok({ products: products }.as_json)
    else
      render_forbidden
    end
  end

  def show
    if current_user.can_see_products?
      product = product.where(id: params[:product][:id]).first if params[:product][:id]
      render_ok product.as_json if product.present?
      render_not_found if product.blank?
    else
      render_forbidden
    end
  end

  def create
    if current_user.can_create_products?
      product = Product.new_from_params(params[:product])
      product.owner_id = current_user.id
      if product.save
        render_created(product.as_json)
      else
        render_bad_request("Some parameters are invalid")
      end
    else
      render_forbidden
    end
  end

  def update
    if current_user.can_create_products? && current_user.owns_product?(params[:product]) || current_user.can_moderate?
      product = Product.where(id: params[:product][:id]).first
      if product.present?
        product.update_allowed_fields(params[:product])
        if product.save
          render_ok(product.as_json)
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
    if current_user.can_create_products? && current_user.owns_product?(params[:product][:id]) || current_user.can_moderate?
      product = Product.where(id: params[:product][:id]).first
      if product.present?
        product.is_archived = true
        product.save
        render_ok
      else
        render_not_found
      end
    else
      render_forbidden
    end
  end

  def check_params
    render_bad_request if params[:product].blank? || !params[:product].is_a?(Hash)
  end
end
