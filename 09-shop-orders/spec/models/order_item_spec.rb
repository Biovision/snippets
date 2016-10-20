require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  subject { build :order_item }

  it_behaves_like 'has_valid_factory'

  describe 'before validation' do
    it 'sets price to item price as integer' do
      subject.valid?
      expect(subject.price).to eq(subject.item.price.to_i)
    end
  end

  describe 'validation' do
    it 'fails without order' do
      subject.order = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:order)
    end

    it 'fails without item' do
      subject.item = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:item)
    end

    it 'fails with too low quantity' do
      subject.quantity = 0
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:quantity)
    end
  end
end
