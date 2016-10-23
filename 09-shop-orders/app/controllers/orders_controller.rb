class OrdersController < ApplicationController
  before_action :restrict_access
  before_action :set_entity

  # get /orders/:id/edit
  def edit
  end

  # patch /orders/:id
  def update
    if @entity.update entity_parameters
      redirect_to @entity, notice: t('orders.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /orders/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('orders.destroy.success')
    end
    redirect_to admin_orders_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Order.find params[:id]
  end

  def entity_parameters
    params.require(:order).permit(Order.entity_parameters)
  end
end
