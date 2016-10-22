module OrderInSession
  extend ActiveSupport::Concern

  protected

  def order_from_session
    @order = Order.find_by(id: session[:order_id].to_i)
  end

  def create_order
    @order = Order.create
    session[:order_id] = @order.id
  end
end
