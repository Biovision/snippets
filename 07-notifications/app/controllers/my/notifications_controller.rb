class My::NotificationsController < ApplicationController
  before_action :restrict_anonymous_access

  # get /my/notifications
  def index
    @collection = Notification.page_for_user current_user, current_page
  end
end
