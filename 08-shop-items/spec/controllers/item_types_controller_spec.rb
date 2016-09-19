require 'rails_helper'

RSpec.describe ItemTypesController, type: :controller do
  let(:user) { create :administrator }
  let!(:entity) { create :item_type }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
    allow(entity.class).to receive(:find).and_call_original
  end

  shared_examples 'forbidden_editing' do
    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'

    it 'redirects to entity administration page' do
      expect(response).to redirect_to(admin_item_type_path(entity))
    end
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'
  end

  describe 'post create' do
    context 'when parameters are valid' do
      let(:action) { -> { post :create, params: { item_type: attributes_for(:item_type) } } }

      it_behaves_like 'entity_creator'

      context 'authorization and redirects' do
        before :each do
          action.call
        end

        it_behaves_like 'page_for_administrator'

        it 'redirects to created entity' do
          expect(response).to redirect_to(admin_item_type_path(entity.class.last))
        end
      end
    end

    context 'when parameters are invalid' do
      let(:action) { -> { post :create, params: { item_type: { name: ' ' } } } }

      it_behaves_like 'entity_constant_count'

      context 'response' do
        before :each do
          action.call
        end

        it_behaves_like 'page_for_administrator'
        it_behaves_like 'http_bad_request'
      end
    end
  end

  describe 'get edit' do
    let(:action) { -> { get :edit, params: { id: entity } } }

    context 'when entity is locked' do
      before :each do
        entity.update! locked: true
        action.call
      end

      it_behaves_like 'forbidden_editing'
    end

    context 'when entity is not locked' do
      before :each do
        action.call
      end

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'entity_finder'
      it_behaves_like 'http_success'
    end
  end

  describe 'patch update' do
    let(:action) { -> { patch :update, params: { id: entity, item_type: { name: 'Changed' } } } }

    context 'when entity is not locked' do
      before :each do
        action.call
      end

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'entity_finder'

      it 'updates entity' do
        entity.reload
        expect(entity.name).to eq('Changed')
      end

      it 'redirects to entity administration page' do
        expect(response).to redirect_to(admin_item_type_path(entity))
      end
    end

    context 'when entity is locked' do
      before :each do
        entity.update! locked: true
        action.call
      end

      it_behaves_like 'forbidden_editing'

      it 'does not update entity' do
        entity.reload
        expect(entity.name).not_to eq('Changed')
      end
    end

    context 'when parameters are invalid' do
      before :each do
        patch :update, params: { id: entity, item_type: { name: ' ' } }
      end

      it_behaves_like 'http_bad_request'

      it 'does not change entity' do
        entity.reload
        expect(entity.name).not_to be_blank
      end
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, params: { id: entity } } }

    it_behaves_like 'entity_destroyer'

    context 'when entity is not locked' do
      before :each do
        action.call
      end

      it_behaves_like 'page_for_administrator'
      it_behaves_like 'entity_finder'

      it 'redirects to entities page' do
        expect(response).to redirect_to(admin_item_types_path)
      end
    end

    context 'when entity is locked' do
      before :each do
        entity.update! locked: true
      end

      it_behaves_like 'entity_constant_count'

      context 'redirecting' do
        before :each do
          action.call
        end

        it_behaves_like 'forbidden_editing'
      end
    end
  end
end
