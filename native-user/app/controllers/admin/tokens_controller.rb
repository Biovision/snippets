class Admin::TokensController < ApplicationController
  before_action :restrict_access

  def index
    @collection = Token.page_for_administration current_page
  end

  protected

  def restrict_access
    require_role :administrator
  end
end
