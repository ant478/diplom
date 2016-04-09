class Api::CommentsController < ApplicationController
  def index
    if current_user.can_see_products?
      comments = Comment.where_params(params[:comment])
      comments = comments.map{ |comment| comment.as_json_full }
      render_ok({ comments: comments }.as_json)
    else
      render_forbidden
    end
  end

  def create
    if current_user.can_comment?
      comment = Comment.new_from_params(params[:comment])
      if comment.save
        comment.product.rating += comment.rate
        comment.product.rates_count++
        comment.product.save
        render_ok
      else
        render_bad_request
      end
    else
      render_forbidden
    end
  end

  def destroy
    if current_user.can_moderate? || current_user.id == params[:comment][:user_id]
      comment = Comment.where(id: params[:comment][:id]).first
      if comment.present?
        comment.destroy
        render_ok
      else
        render_not_found
      end
    else
      render_forbidden
    end
  end

  def check_params
    render_bad_request if params[:comment].blank? || !params[:comment].is_a?(Hash)
  end
end
