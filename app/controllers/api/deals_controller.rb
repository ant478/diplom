class Api::DealsController < ApplicationController
  def index
    if current_user.can_see_products?
      #deals = Deal.where_params(params[:deal])
      deals = Deal.all
      deals = deals.map{ |deal| deal.as_json }
      render_ok({ deals: deals }.as_json)
    else
      render_forbidden
    end
  end

  def create
    if current_user.can_buy_products?
      deal = Deal.new_from_params(params[:deal])
      if deal.buyer_id == current_user.id && deal.save
        render_created(deal.as_json)
      else
        render_bad_request
      end
    else
      render_forbidden
    end
  end

  def check_params
    render_bad_request if params[:deal].blank? || !params[:deal].is_a?(Hash)
  end
end
