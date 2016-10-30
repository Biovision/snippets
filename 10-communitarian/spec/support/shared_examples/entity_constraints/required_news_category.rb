require 'rails_helper'

RSpec.shared_examples_for 'required_news_category' do
  describe 'validation' do
    it 'fails without news_category' do
      subject.news_category = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:news_category)
    end
  end
end
