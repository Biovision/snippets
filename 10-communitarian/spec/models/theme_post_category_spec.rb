require 'rails_helper'

RSpec.describe ThemePostCategory, type: :model do
  subject { build :theme_post_category }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_post_category'
  it_behaves_like 'required_theme'
end
