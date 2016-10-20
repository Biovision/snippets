require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { build :order }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'

  describe 'after initialize' do
    it 'generates slug' do
      entity = Order.new
      expect(entity.slug).not_to be_blank
    end
  end

  describe 'add_item' do
    let!(:item) { create :item }
    let(:action) { -> { subject.add_item(item) } }

    before :each do
      subject.save!
      expect(subject).to receive(:recalculate!)
    end

    context 'when item is already in order' do
      before :each do
        create :order_item, order: subject, item: item
      end

      it 'does not create new record in OrderItem' do
        expect(action).not_to change(OrderItem, :count)
      end

      it 'adds item to order_item' do
        expect_any_instance_of(OrderItem).to receive(:add).with(1)
        action.call
      end
    end

    context 'when item is not in order' do
      it 'creates new record in OrderItem' do
        expect(action).to change(OrderItem, :count).by(1)
      end
    end
  end

  describe 'remove_item' do
    let!(:item) { create :item }
    let(:action) { -> { subject.remove_item(item) } }

    before :each do
      subject.save!
    end

    context 'when item exists' do
      before :each do
        create :order_item, order: subject, item: item
      end

      it 'decrements item count for order_item' do
        expect_any_instance_of(OrderItem).to receive(:remove).with(1)
        action.call
      end

      it 'recalculates order parameters' do
        expect(subject).to receive(:recalculate!)
        action.call
      end
    end

    context 'when item does not exist' do
      it 'does not send #remove to any instance of order_link' do
        expect_any_instance_of(OrderItem).not_to receive(:remove)
        action.call
      end
    end
  end
end
