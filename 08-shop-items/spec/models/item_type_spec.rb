require 'rails_helper'

RSpec.describe ItemType, type: :model do
  subject { build :item_type }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_name'
  it_behaves_like 'has_unique_name'
end
