require 'rails_helper'

RSpec.describe "merchant's discounts index page" do 
  before(:each) do 
    @merchant = create(:merchant)
    @merchant2 = create(:merchant)
    @discount1 = @merchant.discounts.create!(discount: 0.10, threshold: 10)
    @discount2 = @merchant.discounts.create!(discount: 0.15, threshold: 15)
    @discount3 = @merchant2.discounts.create!(discount: 0.20, threshold: 20)

    visit merchant_discounts_path(@merchant)
  end 
  it 'shows all discounts and their attributes' do 
    expect(page).to have_content(@discount1.id)
    expect(page).to have_content(@discount1.threshold)
    expect(page).to have_content("#{(@discount1.discount * 100).round(2)}%")
    expect(page).to have_content(@discount2.id)
    expect(page).to have_content(@discount2.threshold)
    expect(page).to have_content("#{(@discount2.discount * 100).round(2)}%")
    expect(page).not_to have_content(@discount3.id)
    expect(page).not_to have_content(@discount3.threshold)
    expect(page).not_to have_content("#{(@discount3.discount * 100).round(2)}%")
  end

  it "has links to each discount's show page" do 
    click_on "#{@discount1.id}"

    expect(current_path).to eq(merchant_discount_path(@merchant, @discount1))
  end 

  it "lists the next three US holidays" do 
    expect(page).to have_content("Thanksgiving Day")
    expect(page).to have_content("Christmas Day")
    expect(page).to have_content("New Year's Day")
  end 

  it 'has a link to create a new discount' do 
    click_on "Create New Discount"

    expect(current_path).to eq(new_merchant_discount_path(@merchant))
  end 

  it 'has links to delete each discount' do 
    within "#discount-#{@discount1.id}" do 
      click_link "Delete Discount"
    end 

    expect(current_path).to eq(merchant_discounts_path(@merchant))
    expect(page).to have_content(@discount2.id)
    expect(page).to have_content(@discount2.threshold)
    expect(page).to have_content("#{(@discount2.discount * 100).round(2)}%")
    expect(page).not_to have_content(@discount1.id)
    expect(page).not_to have_content(@discount1.threshold)
    expect(page).not_to have_content("#{(@discount1.discount * 100).round(2)}%")
  end 
end 