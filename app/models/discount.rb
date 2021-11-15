class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :discount
  validates_presence_of :threshold
  validates_presence_of :merchant_id
end