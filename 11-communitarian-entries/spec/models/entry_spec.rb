require 'rails_helper'

RSpec.describe Entry, type: :model do
  subject { build :entry }

  let!(:generally_accessible_entry) { create :entry }
  let!(:entry_for_community) { create :entry_for_community }
  let!(:entry_for_followees) { create :entry_for_followees }
  let!(:personal_entry) { create :personal_entry }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'
  it_behaves_like 'required_body'

  describe 'vefore validation' do
    it 'converts empty title to nil slug' do
      subject.valid?
      expect(subject.slug).to be_nil
    end

    it 'normalizes non-empty title' do
      subject.title = ' Сон  в  тестах! '
      subject.valid?
      expect(subject.slug).to eq('son-v-testakh')
    end
  end

  describe 'validation' do
    it 'fails without privacy' do
      subject.privacy = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:privacy)
    end

    it 'fails for foreign community'
  end

  describe '#visible_to?' do
    before :each do
      subject.user = create :user
    end

    shared_examples 'visible_to_anonymous' do
      it 'returns true for anonymous user' do
        expect(subject).to be_visible_to(nil)
      end
    end

    shared_examples 'invisible_to_anonymous' do
      it 'returns false for anonymous user' do
        expect(subject).not_to be_visible_to(nil)
      end
    end

    shared_examples 'visible_to_other_user' do
      it 'returns true other user' do
        user = create :user
        expect(subject).to be_visible_to(user)
      end
    end

    shared_examples 'invisible_to_other_user' do
      it 'returns false for other user' do
        user = create :user
        expect(subject).not_to be_visible_to(user)
      end
    end

    shared_examples 'visible_to_followees' do
      it 'returns true for followee' do
        followee = create :user
        allow(subject.user).to receive(:follows?).with(followee).and_return(true)
        expect(subject).to be_visible_to(followee)
      end
    end

    shared_examples 'invisible_to_followees' do
      it 'returns true for followee' do
        followee = create :user
        allow(subject.user).to receive(:follows?).with(followee).and_return(false)
        expect(subject).not_to be_visible_to(followee)
      end
    end

    shared_examples 'visible_to_owner' do
      it 'returns true for owner' do
        expect(subject).to be_visible_to(subject.user)
      end
    end

    context 'when entry is generally accessible' do
      it_behaves_like 'visible_to_anonymous'
      it_behaves_like 'visible_to_other_user'
      it_behaves_like 'visible_to_followees'
      it_behaves_like 'visible_to_owner'
    end

    context 'when entry is visible to community' do
      before :each do
        subject.privacy = Entry.privacies[:visible_to_community]
      end

      it_behaves_like 'invisible_to_anonymous'
      it_behaves_like 'visible_to_other_user'
      it_behaves_like 'visible_to_followees'
      it_behaves_like 'visible_to_owner'
    end

    context 'when entry is visible to followees' do
      before :each do
        subject.privacy = Entry.privacies[:visible_to_followees]
      end

      it_behaves_like 'invisible_to_anonymous'
      it_behaves_like 'invisible_to_other_user'
      it_behaves_like 'visible_to_followees'
      it_behaves_like 'visible_to_owner'
    end

    context 'when entry is personal' do
      before :each do
        subject.privacy = Entry.privacies[:personal]
      end

      it_behaves_like 'invisible_to_anonymous'
      it_behaves_like 'invisible_to_other_user'
      it_behaves_like 'invisible_to_followees'
      it_behaves_like 'visible_to_owner'
    end
  end

  describe '::page_for_administration' do
    let!(:result) { Entry.page_for_administration(1) }

    it 'includes generally accessible entries' do
      expect(result).to include(generally_accessible_entry)
    end

    it 'includes entries for community' do
      expect(result).to include(entry_for_community)
    end

    it 'does not include entries for followees' do
      expect(result).not_to include(entry_for_followees)
    end

    it 'does not include personal entries' do
      expect(result).not_to include(personal_entry)
    end
  end

  describe '::page_for_visitors' do
    context 'when user is anonymous' do
      let!(:result) { Entry.page_for_visitors(nil, 1) }

      it 'includes generally accessible entries' do
        expect(result).to include(generally_accessible_entry)
      end

      it 'does not include entries for community' do
        expect(result).not_to include(entry_for_community)
      end

      it 'does not include entries for followees' do
        expect(result).not_to include(entry_for_followees)
      end

      it 'does not include personal entries' do
        expect(result).not_to include(personal_entry)
      end
    end

    context 'when user is not anonymous' do
      let!(:result) { Entry.page_for_visitors(create(:user), 1) }

      it 'includes generally accessible entries' do
        expect(result).to include(generally_accessible_entry)
      end

      it 'includes entries for community' do
        expect(result).to include(entry_for_community)
      end

      it 'does not include entries for followees' do
        expect(result).not_to include(entry_for_followees)
      end

      it 'does not include personal entries' do
        expect(result).not_to include(personal_entry)
      end
    end
  end

  describe '::page_for_owner' do
    let!(:result) { Entry.page_for_owner(personal_entry.user, 1) }

    it 'includes owned entry' do
      expect(result).to include(personal_entry)
    end

    it 'does not include foreign entry' do
      expect(result).not_to include(generally_accessible_entry)
    end
  end
end
