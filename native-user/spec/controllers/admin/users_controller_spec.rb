require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:current_user) { create :administrator }
  let!(:entity) { create :user }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(current_user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'collection_assigner'
  end
end
