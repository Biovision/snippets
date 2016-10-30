require 'rails_helper'

RSpec.describe Api::ThemesController, type: :controller do
  before :each do
    allow(subject).to receive(:require_role)
  end

  describe 'put lock' do
    let(:entity) { create :theme }

    before :each do
      put :lock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_locker'
  end

  describe 'delete unlock' do
    let(:entity) { create :theme, locked: true }

    before :each do
      delete :unlock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_unlocker'
  end
end
