require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  let!(:entity) { create :category }

  it_behaves_like 'entity_for_administration'

  describe 'get index' do
    before :each do
      allow(subject).to receive(:require_role)
      allow(entity.class).to receive(:for_tree).and_call_original
      get :index
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'http_success'

    it 'sends :for_tree to Category' do
      expect(entity.class).to have_received(:for_tree).with(no_args)
    end
  end

  describe 'get items' do
    pending
  end
end
