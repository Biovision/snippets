require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  let!(:entity) { create :category }

  it_behaves_like 'list_for_administrator'
end
