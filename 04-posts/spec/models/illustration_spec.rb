require 'rails_helper'

RSpec.describe Illustration, type: :model do
  subject { build :figure }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_post'
  it_behaves_like 'required_image'
end
