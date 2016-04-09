class Api::TransactionsController < ApplicationController
  before_action :check_params

  def index
    if current_user.can_see_statistics?
      transactions = Transaction.where_params(params[:transaction])
      transactions = transactions.map{ |transaction| transaction.as_json_full }
      render_ok({ transactions: transactions }.as_json)
    else 
      render_forbidden
    end
  end

  def check_params
    render_bad_request if params[:transaction].blank? || !params[:transaction].is_a?(Hash)
  end
end
