require 'rails_helper'

RSpec.describe Item, type: :model do
  subject { build :item }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_name'

  describe 'after initialize' do
    it 'sets next priority' do
      subject.save!
      entity = Item.new category: subject.category
      expect(entity.priority).to eq(subject.priority + 1)
    end
  end

  describe 'before validation' do
    it 'generates slug as transliterated name' do
      subject.name = '  Товар в тестах!  '
      subject.valid?
      expect(subject.slug).to eq('tovar-v-testakh')
    end

    it 'sets zero price to nil' do
      subject.price = 0
      subject.valid?
      expect(subject.price).to be_nil
    end

    it 'sets zero old_price to nil' do
      subject.old_price = 0
      subject.valid?
      expect(subject.old_price).to be_nil
    end
  end

  describe 'validation' do
    it 'fails with negative price' do
      subject.price = -1
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:price)
    end

    it 'fails with negative old price' do
      subject.old_price = -1
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:old_price)
    end

    it 'fails without status' do
      subject.status = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:status)
    end
  end
end
