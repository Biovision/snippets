require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create :manager }
  let!(:entity) { create :category }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'get new' do
    before(:each) { get :new }

    it_behaves_like 'page_for_manager'

    it 'assigns new instance of Category to @entity' do
      expect(assigns[:entity]).to be_a_new(Category)
    end
  end

  describe 'post create' do
    let(:action) { -> { post :create, category: attributes_for(:category) } }

    context 'authorization and redirects' do
      before(:each) { action.call }

      it_behaves_like 'page_for_manager'

      it 'redirects to created category' do
        expect(response).to redirect_to(Category.last)
      end
    end

    context 'database change' do
      it 'inserts row into categories table' do
        expect(action).to change(Category, :count).by(1)
      end
    end
  end

  describe 'get show' do
    before(:each) { get :show, id: entity }

    it_behaves_like 'page_for_manager'
    it_behaves_like 'entity_assigner'
  end

  describe 'get edit' do
    before(:each) { get :edit, id: entity }

    it_behaves_like 'page_for_manager'
    it_behaves_like 'entity_assigner'
  end

  describe 'patch update' do
    before(:each) do
      patch :update, id: entity, category: { name: 'Changed' }
    end

    it_behaves_like 'page_for_manager'
    it_behaves_like 'entity_assigner'

    it 'updates category' do
      entity.reload
      expect(entity.name).to eq('Changed')
    end

    it 'redirects to category page' do
      expect(response).to redirect_to(entity)
    end
  end

  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, id: entity } }

    context 'redirects and roles' do
      before(:each) { action.call }

      it_behaves_like 'page_for_manager'

      it 'redirects to categories page' do
        expect(response).to redirect_to(admin_categories_path)
      end
    end

    it 'deletes category from database' do
      expect(action).to change(Category, :count).by(-1)
    end
  end
end
