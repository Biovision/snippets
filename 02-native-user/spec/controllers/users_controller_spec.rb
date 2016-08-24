require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:current_user) { create :administrator }
  let!(:entity) { create :user }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(current_user)
    allow(User).to receive(:with_long_slug).and_return(entity)
    allow(User).to receive(:find).and_call_original
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_administrator'
  end

  describe 'post create' do
    let(:params) { { user: attributes_for(:user).merge(network: 'native') } }
    let(:action) { -> { post :create, params: params } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'page_for_administrator'

      it 'redirects to created user' do
        expect(response).to redirect_to(User.last)
      end
    end

    context 'database change' do
      it 'inserts row into users table' do
        expect(action).to change(User, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, params: { id: entity } }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'
  end

  describe 'get edit' do
    before(:each) { get :edit, params: { id: entity } }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'
  end

  describe 'patch update' do
    before(:each) do
      patch :update, params: { id: entity, user: { name: 'changed' } }
    end

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'entity_finder'

    it 'updates user' do
      entity.reload
      expect(entity.name).to eq('changed')
    end

    it 'redirects to user page' do
      expect(response).to redirect_to(entity)
    end
  end

  describe 'delete destroy' do
    before(:each) { delete :destroy, params: { id: entity } }

    context 'authorization' do
      it_behaves_like 'page_for_administrator'

      it 'redirects to administrative users page' do
        expect(response).to redirect_to(admin_users_path)
      end
    end

    it 'marks user as deleted' do
      entity.reload
      expect(entity).to be_deleted
    end
  end
end