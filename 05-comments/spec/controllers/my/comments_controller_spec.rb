require 'rails_helper'

RSpec.describe My::CommentsController, type: :controller do
  let!(:user) { create :user }
  let!(:entity) { create :comment, user: user }
  let!(:foreign_entity) { create :comment }

  before :each do
    allow(subject).to receive(:restrict_anonymous_access)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    let!(:deleted_entity) { create :comment, user: user, deleted: true }

    before(:each) { get :index }

    it_behaves_like 'page_for_user'
    it_behaves_like 'collection_assigner'
    it_behaves_like 'excluded_foreign_entity'

    it 'does not show deleted entities' do
      expect(assigns[:collection]).not_to include(:deleted_entity)
    end
  end
end
