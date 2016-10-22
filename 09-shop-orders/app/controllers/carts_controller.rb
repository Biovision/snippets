class CartsController < ApplicationController
  include OrderInSession

  before_action :order_from_session
  before_action :check_order_id, except: [:show, :result]

  # get /cart
  def show
  end

  # get /cart/edit
  def edit
  end

  # patch /cart
  def update
    if @order.update(order_parameters.merge(status: Order.statuses[:placed]))
      session[:order_id] = nil
      flash[:result] = t('carts.update.success')
      redirect_to result_cart_path
    else
      render :edit, status: :bad_request
    end
  end

  # delete /cart
  def destroy
    if @order.is_a?(Order)
      @order.rejected!
      session[:order_id] = nil
      flash[:result] = t('carts.destroy.success')
    end

    redirect_to result_cart_path
  end

  # get /cart/result
  def result
    if @order.is_a?(Order)
      redirect_to cart_path
    end
  end

  private

  def order_parameters
    permitted = Order.order_parameters
    params.require(:order).permit(permitted).merge(tracking_for_entity)
  end

  def check_order_id
    redirect_to cart_path if @order.nil?
  end
end
