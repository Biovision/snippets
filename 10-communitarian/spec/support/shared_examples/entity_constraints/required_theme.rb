require 'rails_helper'

RSpec.shared_examples_for 'required_theme' do
  describe 'validation' do
    it 'fails without theme' do
      subject.theme = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:theme)
    end
  end
end
