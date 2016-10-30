require 'rails_helper'

RSpec.shared_examples_for 'required_post_category' do
  describe 'validation' do
    it 'fails without post_category' do
      subject.post_category = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:post_category)
    end
  end
end
