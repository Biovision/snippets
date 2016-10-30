require 'rails_helper'

RSpec.describe Admin::ThemesController, type: :controller do
  let!(:entity) { create :theme }

  it_behaves_like 'list_for_administration'
  it_behaves_like 'entity_for_administration'
end
