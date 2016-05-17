require 'rails_helper'

RSpec.describe Admin::TokensController, type: :controller do
  let(:user) { create :administrator }
  let!(:entity) { create :token }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_administrator'
    it_behaves_like 'collection_assigner'
  end
end
