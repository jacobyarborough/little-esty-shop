require 'rails_helper'

RSpec.describe 'New Discount Page' do 
  before(:each) do 
    @merchant = create(:merchant)
    @discount1 = @merchant.discounts.create!(discount: 0.10, threshold: 10)
    @discount2 = @merchant.discounts.create!(discount: 0.15, threshold: 15)

    visit new_merchant_discount_path(@merchant)
  end 

  it 'has a form to create a new merchant discount' do 
    fill_in "Threshold", with: 25
    fill_in "Discount", with: 0.3
    click_on "Create Discount"

    expect(current_path).to eq(merchant_discounts_path(@merchant))
    expect(page).to have_content("Item Count Minimum: 25")
    expect(page).to have_content("Percent Discount: 30.0%")
  end 
end 