require 'rails_helper' 

RSpec.describe do 
  describe 'discount edit page' do 
    before(:each) do 
      @merchant1 = create(:merchant)
      @discount1 = @merchant1.discounts.create!(discount: 0.10, threshold: 10)

      visit edit_merchant_discount_path(@merchant1, @discount1)
    end 

    it 'has a form to update the item' do 
      fill_in "Discount", with: 0.30
      fill_in "Threshold", with: 30
      click_button "Update Discount"
  
      expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
      expect(page).to have_content(@discount1.id)
      expect(page).to have_content("Item Count Minimum: 30")
      expect(page).to have_content("Percent Discount: 30.0%")
    end 

    it 'handles incorrect submissions' do
      fill_in "Discount", with: " "
      click_button "Update Discount"
  
      expect(current_path).to eq(edit_merchant_discount_path(@merchant1, @discount1))
      expect(page).to have_content("Please enter valid data")
    end
  end 
end 