require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do
  let(:user) { create :administrator }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'post toggle' do
    before(:each) { post :toggle, params: { id: entity, parameter: :visible } }

    context 'when entity is not locked' do
      let(:entity) { create :item }

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'http_success'

      it 'toggles parameters' do
        entity.reload
        expect(entity).not_to be_visible
      end
    end

    context 'when entity is locked' do
      let(:entity) { create :item, locked: true }

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'http_forbidden'

      it 'does not toggle parameter' do
        entity.reload
        expect(entity).to be_visible
      end
    end
  end

  describe 'put lock' do
    let(:entity) { create :item }

    before :each do
      put :lock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_locker'
  end

  describe 'delete unlock' do
    let(:entity) { create :item, locked: true }

    before :each do
      delete :unlock, params: { id: entity }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_unlocker'
  end

  describe 'post priority' do
    let!(:entity) { create :item }
    let(:action) { -> { post :priority, params: { id: entity, delta: 1 } } }

    before :each do
      allow(entity.class).to receive(:find).and_return(entity)
    end

    context 'authorization' do
      before :each do
        action.call
      end

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'entity_finder'
    end

    context 'changing entity' do
      it 'changes priority' do
        expect(action).to change(entity, :priority).by(1)
      end
    end
  end
end
