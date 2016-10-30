require 'rails_helper'

RSpec.describe ThemeNewsCategory, type: :model do
  subject { build :theme_news_category }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_news_category'
  it_behaves_like 'required_theme'
end
