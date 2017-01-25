class Api::NotificationsController < ApplicationController
  before_action :set_entity

  # delete /api/notifications/:id
  def destroy
    @entity.destroy
    head :no_content
  end

  private

  def set_entity
    @entity = Notification.find_by! id: params[:id], user: current_user
  end
end
