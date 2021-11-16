# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

require 'factory_bot_rails'

merchant1 = FactoryBot.create :merchant
merchant2 = FactoryBot.create :merchant

customer = FactoryBot.create :customer

invoice1 = FactoryBot.create :invoice, { customer_id: customer.id }
invoice2 = FactoryBot.create :invoice, { customer_id: customer.id }
invoice3 = FactoryBot.create :invoice, { customer_id: customer.id }

item1 = FactoryBot.create :item, { merchant_id: merchant1.id }
item2 = FactoryBot.create :item, { merchant_id: merchant1.id }
item3 = FactoryBot.create :item, { merchant_id: merchant2.id }

invoice_item1 = FactoryBot.create :invoice_item,
                              { invoice_id: invoice1.id, item_id: item1.id, unit_price: 50, quantity: 9 }
invoice_item2 = FactoryBot.create :invoice_item,
                              { invoice_id: invoice2.id, item_id: item2.id, unit_price: 100, quantity: 15 }
invoice_item3 = FactoryBot.create :invoice_item,
                              { invoice_id: invoice3.id, item_id: item3.id, unit_price: 200, quantity: 20 }

discount1 = merchant1.discounts.create!(discount: 0.10, threshold: 10)
discount2 = merchant1.discounts.create!(discount: 0.15, threshold: 15)
discount3 = merchant2.discounts.create!(discount: 0.10, threshold: 10)
discount4 = merchant2.discounts.create!(discount: 0.20, threshold: 15)
