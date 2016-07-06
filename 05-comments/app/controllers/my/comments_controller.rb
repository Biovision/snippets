class My::CommentsController < ApplicationController
  before_action :restrict_anonymous_access

  # get /my/comments
  def index
    @collection = Comment.owned_by(current_user).page_for_visitor current_page
  end
end
