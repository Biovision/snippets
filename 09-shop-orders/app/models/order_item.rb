class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  before_validation :normalize_price
  validates_numericality_of :quantity, greater_than: 0

  # @param [Integer] quantity
  def add(quantity = 1)
    increment! :quantity, quantity
  end

  # @param [Integer] quantity
  def remove(quantity = 1)
    decrement! :quantity, quantity
    destroy if self.quantity < 1
  end

  private

  def normalize_price
    if price.nil? && !item.nil?
      self.price = item.price.to_i
    end
  end
end
