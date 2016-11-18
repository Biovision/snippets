require 'rails_helper'

RSpec.describe My::EntriesController, type: :controller do
  let(:user) { create :user }
  let(:entity) { create :entry, user: user }

  it_behaves_like 'list_for_owner'
end
