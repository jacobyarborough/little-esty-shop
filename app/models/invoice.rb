class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  validates_presence_of :customer_id
  validates_presence_of :status

  def self.in_progress
    where(status: 'in progress')
  end

  def self.order_from_oldest
    order(created_at: :desc)
  end

  def total_item_revenue_by_merchant(merchant_id)
    invoice_items.joins(:item)
                 .where(items: {merchant_id: merchant_id})
                 .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def total_invoice_revenue(invoice_id)
    invoice_items.joins(:invoice)
                 .where(invoice_items: {invoice_id: invoice_id})
                 .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def discounted_revenue(merchant_id)
    total_amount = 0
    line_items = items.joins('inner join invoice_items ii on ii.item_id = items.id left join discounts d on d.merchant_id = items.merchant_id and ii.quantity >= d.threshold')
                      .select('items.*, ii.*, d.*, RANK() OVER (PARTITION BY items.id ORDER BY d.threshold DESC) AS rank')#.having('rank = 1') -- why wont this work?
                      .where(merchant_id: merchant_id)
    line_items.each do |line|
      if line.rank == 1
        if line.discount != nil
          total_amount += ((line.quantity * line.unit_price) * (1 - line.discount))
        else 
          total_amount += (line.quantity * line.unit_price)
        end 
      end 
    end 
    total_amount
  end 
end