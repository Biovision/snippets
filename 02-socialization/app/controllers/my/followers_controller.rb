class My::FollowersController < ApplicationController
  before_action :restrict_anonymous_access

  # get /my/followers
  def index
    @collection = UserLink.with_followee(current_user).page_for_user(current_page)
  end
end
