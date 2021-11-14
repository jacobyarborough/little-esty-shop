require 'rails_helper'

RSpec.describe "merchant's discounts index page" do 
  before(:each) do 
    @merchant = create(:merchant)
    @discount1 = @merchant.discounts.create!(discount: 0.10, threshold: 10)
    @discount2 = @merchant.discounts.create!(discount: 0.15, threshold: 15)

    visit merchant_discounts_path(@merchant)
  end 
  it 'shows all discounts and their attributes' do 
    expect(page).to have_content(@discount1.id)
    expect(page).to have_content(@discount1.threshold)
    expect(page).to have_content("#{(@discount1.discount * 100).round(2)}%")
    expect(page).to have_content(@discount2.id)
    expect(page).to have_content(@discount2.threshold)
    expect(page).to have_content("#{(@discount2.discount * 100).round(2)}%")
  end 

  it "has links to each discount's show page" do 
    click_on "#{@discount1.id}"

    expect(current_path).to eq(merchant_discount_path(@merchant, @discount1))
  end 
end 