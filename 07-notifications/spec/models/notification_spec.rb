require 'rails_helper'

RSpec.describe Notification, type: :model do
  subject { build :notification }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'
end
