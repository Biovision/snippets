require 'rails_helper'

RSpec.describe Api::NotificationsController, type: :controller do
  let!(:user) { create :user }
  let!(:entity) { create :notification, user: user }
  let!(:foreign_entity) { create :notification }

  before :each do
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'delete destroy' do
    context 'when entity is owned by user' do
      let(:action) { -> { delete :destroy, id: entity } }

      it 'removes notification from database' do
        expect(action).to change(Notification, :count).by(-1)
      end

      it 'responds with status no content' do
        action.call
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when entity is not owned by user' do
      let(:action) { -> { delete :destroy, id: foreign_entity } }

      it 'responds with error 404' do
        expect(action).to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
