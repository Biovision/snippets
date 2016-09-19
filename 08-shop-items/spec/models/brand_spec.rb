require 'rails_helper'

RSpec.describe Brand, type: :model do
  subject { build :brand }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_unique_name'
  it_behaves_like 'has_unique_generated_slug'
  it_behaves_like 'required_name'

  describe 'after initialize' do
    it 'sets next priority' do
      subject.save!
      entity = Brand.new
      expect(entity.priority).to eq(subject.priority + 1)
    end
  end

  describe 'before validation' do
    it 'generates slug as transliterated name' do
      subject.name = '  Производитель в тестах!  '
      subject.valid?
      expect(subject.slug).to eq('proizvoditel-v-testakh')
    end
  end
end
