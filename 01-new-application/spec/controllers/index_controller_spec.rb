require 'rails_helper'

RSpec.describe IndexController, type: :controller do
  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'http_success'
  end
end
