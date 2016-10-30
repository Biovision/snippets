require 'rails_helper'

RSpec.describe Api::RegionsController, type: :controller do
  before :each do
    allow(subject).to receive(:require_role)
  end

  describe 'put lock' do
    let(:entity) { create :region }

    before :each do
      put :lock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_locker'
  end

  describe 'delete unlock' do
    let(:entity) { create :region, locked: true }

    before :each do
      delete :unlock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_unlocker'
  end
end
