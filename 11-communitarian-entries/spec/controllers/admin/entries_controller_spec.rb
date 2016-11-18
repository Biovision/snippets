require 'rails_helper'

RSpec.describe Admin::EntriesController, type: :controller do
  let!(:entity) { create :entry }

  it_behaves_like 'list_for_administration'
  it_behaves_like 'deletable_entity_for_administration'
end
