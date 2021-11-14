class DiscountsController < ApplicationController
  def index 
    if params[:merchant_id]
      @discounts = Discount.where(merchant_id: params[:merchant_id])
    else 
      @discounts = Discount.all
    end 
  end 
end