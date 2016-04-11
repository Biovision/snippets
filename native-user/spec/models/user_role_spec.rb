require 'rails_helper'

RSpec.describe UserRole, type: :model do
  let(:model) { :user_role }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_user'

  describe 'validation' do
    it 'fails without role' do
      entity = build model, role: nil
      expect(entity).not_to be_valid
    end

    it 'fails with non-unique pair' do
      existing = create model
      entity   = build model, user: existing.user
      expect(entity).not_to be_valid
    end
  end

  describe '#user_has_role?' do
    let(:user) { create :user }

    before :each do
      create model, user: user, role: :administrator
    end

    it 'returns true for existing pair' do
      expect(UserRole).to be_user_has_role(user, :administrator)
    end

    it 'returns false for absent pair' do
      expect(UserRole).not_to be_user_has_role(user, :moderator)
    end

    it 'returns false for unknown role' do
      expect(UserRole).not_to be_user_has_role(user, :non_existent)
    end
  end
end
