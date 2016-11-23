class My::FolloweesController < ApplicationController
  before_action :restrict_anonymous_access

  # get /my/followees
  def index
    @collection = UserLink.with_follower(current_user).page_for_user(current_page)
  end
end
