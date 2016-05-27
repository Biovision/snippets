require 'rails_helper'

RSpec.describe My::IndexController, type: :controller do
  before :each do
    allow(subject).to receive(:restrict_anonymous_access)
  end

  describe 'get index' do
    before(:each) { get :index }
    
    it 'restricts anonymous access' do
      expect(subject).to have_received(:restrict_anonymous_access)
    end
  end
end
