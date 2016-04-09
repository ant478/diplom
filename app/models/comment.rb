class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  validates :product_id, presence: true #?
  validates :user_id, presence: true #?

  SEARCH_FIELDS = [
    "rate",
    "text",
    "product_id",
    "user_id"
  ]

  RANGE_SEARCH_FIELDS = [
    "created_at"
  ]

  def self.where_params(params)
    clean_params = {}
    SEARCH_FIELDS.each{ |field|
      clean_params[field] = params[field] if params[field]
    }
    comments = Comment.where(clean_params)
    RANGE_SEARCH_FIELDS.each{ |field| 
      comments = comments.where(params[field])
    }
    return comments
  end

  def self.new_from_params(params)
    comment = Comment.new
    comment.rate = params[:rate]
    comment.text = params[:text]
    comment.product_id = params[:product_id]
    comment.user_id = params[:user_id]
  end
end
