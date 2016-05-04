require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:model) { :comment }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'

  describe 'validation' do
    it 'fails without commentable object' do
      entity = build model, commentable: nil
      expect(entity).not_to be_valid
    end

    it 'fails without body' do
      entity = build model, body: ' '
      expect(entity).not_to be_valid
    end

    it 'fails with deleted commentable object' do
      commentable = create :post, deleted: true
      entity      = build model, commentable: commentable
      expect(entity).not_to be_valid
    end

    it 'fails with invisible commentable object' do
      commentable = create :post, visible: false
      entity      = build model, commentable: commentable
      expect(entity).not_to be_valid
    end
  end

  describe 'notify_entry_owner?' do
    let(:owner) { create :confirmed_user }
    let!(:commentable) { create :post, user: owner }

    context 'when entry owner is nil' do
      let!(:entity) { create model, commentable: create(:post) }
      
      before(:each) do
        allow(commentable).to receive(:user).and_return(nil)
      end

      it 'returns false' do
        expect(entity).not_to be_notify_entry_owner
      end
    end

    context 'when entry owner is the same as comment owner' do
      let!(:entity) { create model, commentable: commentable, user: owner }

      it 'returns false' do
        expect(entity).not_to be_notify_entry_owner
      end
    end

    context 'when entry owner is other user' do
      let!(:entity) { create model, commentable: commentable }

      it 'checks if entry owner can receive letters' do
        expect(owner).to receive(:can_receive_letters?)
        entity.notify_entry_owner?
      end

      it 'returns true if entry owner can receive letters' do
        expect(owner).to receive(:can_receive_letters?).and_return(true)
        expect(entity).to be_notify_entry_owner
      end
    end
  end
end
