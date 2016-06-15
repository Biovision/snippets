require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { build :comment }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_user'

  describe 'validation' do
    it 'fails without commentable object' do
      subject.commentable = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:commentable)
    end

    it 'fails without body' do
      subject.body = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end

    it 'fails with deleted commentable object' do
      subject.commentable = create :post, deleted: true
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:commentable)
    end

    it 'fails with invisible commentable object' do
      subject.commentable = create :post, visible: false
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:commentable)
    end
  end

  describe '#notify_entry_owner?' do
    let(:owner) { create :confirmed_user }
    let!(:commentable) { create :post, user: owner }

    context 'when entry owner is nil' do
      before :each do
        subject.commentable = create(:post)
        allow(commentable).to receive(:user).and_return(nil)
      end

      it 'returns false' do
        expect(subject.notify_entry_owner?).not_to be
      end
    end

    context 'when entry owner is the same as comment owner' do
      before :each do
        subject.commentable = commentable
        subject.user = owner
      end

      it 'returns false' do
        expect(subject.notify_entry_owner).not_to be
      end
    end

    context 'when entry owner is other user' do
      before :each do
        subject.commentable = commentable
      end

      it 'checks if entry owner can receive letters' do
        expect(owner).to receive(:can_receive_letters?)
        subject.notify_entry_owner?
      end

      it 'returns true if entry owner can receive letters' do
        expect(owner).to receive(:can_receive_letters?).and_return(true)
        expect(subject.notify_entry_owner).to be
      end
    end
  end
end
