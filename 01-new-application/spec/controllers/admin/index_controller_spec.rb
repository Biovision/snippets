require 'rails_helper'

RSpec.describe Admin::IndexController, type: :controller do
  let(:user) { create :administrator }
  let(:required_roles) { UserRole.roles.keys }

  before :each do
    allow(subject).to receive(:require_role)
    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'required_roles'
    it_behaves_like 'http_success'
  end
end
