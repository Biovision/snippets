require 'rails_helper'

RSpec.describe Admin::ItemTypesController, type: :controller do
  let!(:entity) { create :item_type }

  it_behaves_like 'list_for_administration'
  it_behaves_like 'entity_for_administration'

  describe 'get items' do
    before :each do
      allow(entity.class).to receive(:find).and_call_original
      allow(Item).to receive(:page_for_administration)
      allow(subject).to receive(:require_role)
      get :items, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'http_success'
    it_behaves_like 'entity_finder'

    it 'sends :page_for_administration to Item' do
      expect(Item).to have_received(:page_for_administration)
    end
  end
end
