class Api::TransactionsController < ApplicationController
  #before_action :check_params

  def index
      currencies = Currency.all
      render_ok({ currencies: currencies }.as_json)
    end
  end
end
