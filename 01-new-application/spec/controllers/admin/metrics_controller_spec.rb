require 'rails_helper'

RSpec.describe Admin::MetricsController, type: :controller do
  let!(:entity) { create :metric }

  it_behaves_like 'list_for_administration'
  it_behaves_like 'entity_for_administration'
end
