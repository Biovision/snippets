require 'rails_helper'

RSpec.describe Community, type: :model do
  subject { build :community }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'
  it_behaves_like 'has_unique_name'
  it_behaves_like 'required_name'

  describe 'before validation' do
    it 'strips name' do
      subject.name = ' aaa '
      subject.valid?
      expect(subject.name).to eq('aaa')
    end
  end
end
