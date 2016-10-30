require 'rails_helper'

RSpec.describe Theme, type: :model do
  subject { build :theme }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_unique_name'
  it_behaves_like 'required_name'

  describe 'validation' do
    it 'fails without slug' do
      subject.slug = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'fails with non-unique slug' do
      create :theme, slug: subject.slug
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end
  end
end
