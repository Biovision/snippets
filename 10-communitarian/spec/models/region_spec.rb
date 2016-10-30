require 'rails_helper'

RSpec.describe Region, type: :model do
  subject { build :region }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_name'
  it_behaves_like 'has_unique_name'

  describe 'before validation' do
    it 'normalizes slug' do
      subject.slug = 'MSK'
      subject.valid?
      expect(subject.slug).to eq('msk')
    end
  end

  describe 'validation' do
    it 'fails without slug' do
      subject.slug = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'fails with non-unique slug' do
      create :region, slug: subject.slug
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'fails with invalid slug' do
      subject.slug = '-invalid'
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end
  end
end
