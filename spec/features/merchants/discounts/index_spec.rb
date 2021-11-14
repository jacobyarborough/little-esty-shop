require 'rails_helper'

RSpec.describe "merchant's discounts index page" do 
  before(:each) do 
    @merchant = create(:merchant)
    @discount1 = @merchant.discounts.create!(discount: 0.10, threshold: 10)
    @discount2 = @merchant.discounts.create!(discount: 0.15, threshold: 15)

    visit merchant_discounts_path(@merchant)
  end 
  it 'shows all discounts and their attributes' do 
  end 

  it "has links to each discount's show page" do 
  end 
end 