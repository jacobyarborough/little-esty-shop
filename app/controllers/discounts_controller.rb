class DiscountsController < ApplicationController
  def index 
    if params[:merchant_id]
      @discounts = Discount.where(merchant_id: params[:merchant_id])
      @holiday_facade = HolidayFacade.new
    else 
      @discounts = Discount.all
      @holiday_facade = HolidayFacade.new
    end 
  end 

  def show 
    @discount = Discount.find(params[:id])
  end 

  def new 
    @discount = Discount.new 
    @merchant = Merchant.find(params[:merchant_id])
  end 

  def create 
    discount = Discount.new(discount_params.merge({merchant_id: params[:merchant_id]}))
    discount.save
    redirect_to merchant_discounts_path(params[:merchant_id])
  end 

  def destroy
    discount_record = Discount.find(params[:id])
    discount_record.destroy 
    redirect_to merchant_discounts_path(params[:merchant_id])
  end 

  def edit 
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end 

  def update
    discount = Discount.find(params[:id])
    if discount.update(discount_params)
      flash[:notice] = "Item has been successfully updated"
      redirect_to merchant_discount_path(params[:merchant_id], params[:id])
    else
      flash[:alert] = "Please enter valid data"
      redirect_to edit_merchant_discount_path(params[:merchant_id], params[:id])
    end
  end 

  private
  def discount_params
    params.require(:discount).permit(:discount, :threshold)
  end
end