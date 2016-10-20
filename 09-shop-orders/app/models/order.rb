class Order < ApplicationRecord
  include HasOwner

  PER_PAGE = 10

  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  enum status: [:incomplete, :placed, :processing, :ready, :delivered, :rejected]

  validates_presence_of :slug
  after_initialize :generate_slug

  scope :recent, -> { order 'id desc' }
  scope :within_date, ->(date) { where 'date(created_at) = ?', date.strftime('%Y-%m-%d') }
  scope :with_status, ->(status) { where status: Order.statuses[status] unless status.blank? }
  scope :filtered, ->(f) { with_status(f[:status]) }

  # @param [Integer] page
  # @param [Hash] filter
  def self.page_for_administration(page, filter = {})
    filtered(filter).recent.page(page).per(PER_PAGE)
  end

  # @param [Integer] order_id
  def self.from_session(order_id)
    self.find_by id: order_id unless order_id.nil?
  end

  # @param [Item] item
  # @param [Integer] quantity
  def add_item(item, quantity = 1)
    order_item = order_items.find_by item: item, price: item.price.to_i
    if order_item.is_a? OrderItem
      order_item.add quantity
    else
      order_items.create item: item, quantity: quantity
    end
    recalculate!
  end

  # @param [Item] item
  # @param [Integer] quantity
  def remove_item(item, quantity = 1)
    order_item = order_items.where(item: item).order('price asc').first
    if order_item.is_a? OrderItem
      order_item.remove quantity
      recalculate!
    end
  end

  def has_items_with_empty_price?
    order_items.where(price: 0).present?
  end

  private

  # Generate order number
  def generate_slug
    if self.id.nil?
      last_part = (Order.within_date(Time.now).count + 1).to_s.rjust(2, '0')
      self.slug = Time.now.strftime('%y%m%d') + last_part
    end
  end

  # Recalculate price and item count based on OrderItem data for this order
  def recalculate!
    attributes = { price: 0, items_count: 0 }
    links      = order_items
    links.reload
    links.map do |order_item|
      attributes[:price]       += order_item.price * order_item.quantity
      attributes[:items_count] += order_item.quantity
    end
    update attributes
  end
end
