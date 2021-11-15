require 'rails_helper'

RSpec.describe 'discount show page' do 
  before(:each) do 
    @merchant = create(:merchant)
    @discount1 = @merchant.discounts.create!(discount: 0.10, threshold: 10)

    visit merchant_discount_path(@merchant, @discount1)
  end 

  it "shows the discount's quntity threshold and percentage discount" do 
    expect(page).to have_content(@discount1.id)
    expect(page).to have_content(@discount1.threshold)
    expect(page).to have_content("#{(@discount1.discount * 100).round(2)}%")
  end 
end 