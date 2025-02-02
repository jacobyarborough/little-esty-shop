require 'rails_helper'

RSpec.describe 'merchant invoice show page' do
  before do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)

    @item1 = create :item, { merchant_id: @merchant1.id }
    @item2 = create :item, { merchant_id: @merchant1.id }
    @item3 = create :item, { merchant_id: @merchant2.id }

    @customer = create :customer

    @invoice = create :invoice, { customer_id: @customer.id }

    @transaction = create :transaction, { invoice_id: @invoice.id, result: 'success' }

    @inv_item1 = create :invoice_item, { quantity: 11, unit_price: 1000, item_id: @item1.id, invoice_id: @invoice.id, status: 'pending' }
    @inv_item2 = create :invoice_item, { quantity: 16, unit_price: 1500, item_id: @item2.id, invoice_id: @invoice.id}
    @inv_item3 = create :invoice_item, { quantity: 15, unit_price: 2000, item_id: @item3.id, invoice_id: @invoice.id}

    @discount1 = @merchant1.discounts.create!(discount: 0.10, threshold: 10)
    @discount2 = @merchant1.discounts.create!(discount: 0.15, threshold: 15)
    @discount3 = @merchant2.discounts.create!(discount: 0.10, threshold: 20)

    visit merchant_invoice_path(@merchant1, @invoice)
  end

  it 'when i visit merchant invoice show page' do
    expect(current_path).to eq(merchant_invoice_path(@merchant1, @invoice))
  end

  it 'i see invoice id, status, created_at formatted, and customer first and last' do
    expect(page).to have_content(@invoice.id)
    expect(page).to have_content(@invoice.status)
    expect(page).to have_content(@invoice.created_at.strftime("%A, %B %d, %Y"))
    expect(page).to have_content(@invoice.customer.full_name)
  end

  it 'i see all the items on the invoice with name, quantity, sell price and inv_item status only for this merchant' do
    expect(page).to have_content(@item1.name)
    expect(page).to have_content(@item1.invoice_items.first.quantity)
    expect(page).to have_content(@item1.invoice_items.first.unit_price.fdiv(100))
    expect(page).to have_content(@item1.invoice_items.first.status)
    expect(page).to have_content(@item2.name)
    expect(page).to_not have_content(@item3.name)
  end

  it 'i see total revenue for all of my items on invoice' do
    expect(page).to have_content("Total Merchant Revenue for this Invoice")
  end

  it 'item status is a select field that shows current status and can change status' do
    within("#item-#{@item1.id}") do
      expect(find_field(:invoice_item_status).value).to eq('pending')
      select 'packaged'
      click_button 'Update Item Status'

      expect(current_path).to eq(merchant_invoice_path(@merchant1, @invoice))

      expect(find_field(:invoice_item_status).value).to eq('packaged')
    end
  end

  it 'shows the total discounted revenue' do 
    expect(page).to have_content("Total Discounted Revenue: $303.00")
  end 

  it 'has a link to view discount associated with an item if applicable' do 
    within("#item-#{@item1.id}") do 
      click_link "View Discount"

      expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
    end 

    visit merchant_invoice_path(@merchant1, @invoice)

    within("#item-#{@item2.id}") do 
      click_link "View Discount"

      expect(current_path).to eq(merchant_discount_path(@merchant1, @discount2))
    end 

    visit merchant_invoice_path(@merchant2, @invoice)

    within("#item-#{@item3.id}") do 
      expect(page).not_to have_content("View Discount")
    end 
  end 
end
