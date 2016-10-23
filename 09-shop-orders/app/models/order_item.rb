class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  before_validation :normalize_price
  validates_numericality_of :quantity, greater_than: 0

  # @param [Integer] delta
  def add(delta = 1)
    update(quantity: quantity + delta, price: item.price.to_i)
  end

  # @param [Integer] quantity
  def remove(quantity = 1)
    decrement! :quantity, quantity
    destroy if self.quantity < 1
  end

  def total_price
    quantity * price
  end

  private

  def normalize_price
    if price.nil? && !item.nil?
      self.price = item.price.to_i
    end
  end
end
