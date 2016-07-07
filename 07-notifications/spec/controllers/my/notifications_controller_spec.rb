require 'rails_helper'

RSpec.describe My::NotificationsController, type: :controller do
  let!(:user) { create :user }
  let!(:entity) { create :notification, user: user }
  let!(:foreign_entity) { create :notification }

  before :each do
    allow(subject).to receive(:restrict_anonymous_access)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_user'
    it_behaves_like 'collection_assigner'
    it_behaves_like 'excluded_foreign_entity'
  end
end
